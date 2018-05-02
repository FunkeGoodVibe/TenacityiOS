//
//  QuestionViewController.swift
//  FirebaseApp
//
//  Created by Funke Sowole on 21/02/2018.
//  Copyright © 2018 Funke Sowole. All rights reserved.
//
// Pulls the Homework questions from the Firebase database (Database\Questions) tree
// Stores the Users Homework Responses in the Firebase Database (Database\Users\Answers) tree
//  Presented this way for database tidyness
// Also saves the users responses on save, in a variable manually, so the user can come back to an answer once they log out for example.
// Sends an e-mail to the current users group faciliator on save, (getting data from the firebase database) so the facilitaor can have a copy of the parents Homework Answers.

import UIKit
import FirebaseDatabase
import FirebaseAuth
import MessageUI

class QuestionViewController: UITableViewController {
    
    var answersRef:DatabaseReference!
    
    var weekNumber:Int!
    var questions = [String]()
    var answers = [String]() // store users answers to avoid dequeue problem

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "QuestionTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "questionCell")
         
        let nibButton = UINib(nibName: "ButtonTableViewCell", bundle: nil)
        self.tableView.register(nibButton, forCellReuseIdentifier: "buttonCell")

        if let userID = Auth.auth().currentUser?.uid {
            self.answersRef =  Database.database().reference().child("/Users/\(userID)/answers/week\(self.weekNumber!)/")
        }
        print("Week Number: \(self.weekNumber)")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.observeQuestions()
        
    }
    
    //Read the list of questions from Firebase
    func observeQuestions() {
        let questionsRef = Database.database().reference().child("/Homework/Session \(self.weekNumber!)/Questions")
        
        questionsRef.observe(.value, with: { snapshot in
            
            var tempPosts = [String]()
            self.answers = []
            
            var questionNumber = 0
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? String {
                    tempPosts.append(dict)
                    let currentQuestionNumber = questionNumber  //stores the current question number
                    self.answersRef.child("answer\(questionNumber + 1)").observe(.value, with: { (answerSnapshot) in
                        if let value = answerSnapshot.value as? String {
                        self.answers[currentQuestionNumber] = value
                            self.tableView.reloadData()
                                //Complete pulling questions from Firebase.
                        }
                        
                    })
                    
                    self.answers.append("")
                    //Add a blank space to the homework responses.
                    //As just reading questions from Firebase at this stage
                }
                questionNumber += 1
                    //read the next question number from the Firebase database
            }
            
            //store the questions (string array)
            self.questions = tempPosts
            self.tableView.reloadData()
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    //number of columns* for each question.
    //value = 1
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //number of rows* for each question
    //value = number of questions from the Firebase database
        //(Plus one, as FB database starts at 0)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.questions.count + 1
    }

    
    //display the answer field to answer questions, and behaviour when user presses submit
    //sends an e-mail to the users facilitator if they 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < self.questions.count {       //if the cell is too large for the screen, deque the cell (i.e. recycle the cell)
            let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as! QuestionTableViewCell
            
            let row = indexPath.row
            let question = self.questions[row]
            let answer = self.answers[row]
            cell.questionLabel.text = question
            cell.answerTextView.text = answer
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell") as! ButtonTableViewCell
            cell.action = {
                print("Submitting")
                let cellsOnScreen = self.tableView.visibleCells
                cellsOnScreen.forEach({ (cell) in
                    
                    //re-use the previous cell for the next question, if the number of questions is too large for the screen.
                    if let indexPath = tableView.indexPath(for: cell),
                        let questionCell = cell as? QuestionTableViewCell,
                        let text = questionCell.answerTextView.text {
                        self.answers[indexPath.row] = text
                    }
                })
                
                //if the user is signed in / authenticated:
                if let userID = Auth.auth().currentUser?.uid {  //then, store the users answers in Firebase.
                    print(userID)
                //2. "/users/[user id]/answers/week#/answer#"
                    var dictionary = [String:String]()
                    for i in 0..<self.answers.count {
                        if self.answers[i] != "" {
                            dictionary["answer\(i+1)"] = self.answers[i]
                        }
                    }
                    let path = "/Users/\(userID)/answers/week\(self.weekNumber!)/"
                    print(path) //store the users responses under "thier" profile. (not under the homework task)
                    
                    self.answersRef.setValue(dictionary)    //store the list of user response
                    
                    //check which group the user is in, (to send the e-mail to their faciliator (from Firebase) once they press send.
            
                    Database.database().reference(withPath: "/Users/\(userID)").observeSingleEvent(of: .value, with: { (snapShot) in
                        guard let values = snapShot.value as? [String: Any], let group = values["group"] as? String else {
                            print("No group")       //test statement if the user does not have a group.
                            return
                        }
                        Database.database().reference(withPath: "User groups/\(group)/facilmail").observeSingleEvent(of: .value, with: { (snapShot) in
                            guard let email = snapShot.value as? String else {  //read the Firebase database to check the facil e-mail (child attribute of the user group)
                                print("No facilmail")   //else test print statement.
                                return
                            }
                            print(email)
                            guard MFMailComposeViewController.canSendMail()  else{      //check if unable to send an e-mail.
                                print("Not able to send an email")
                                return
                            }
                            
                            //code to send the users answers in an e-mail, if an facil e-mail is successful.
                            //otherwise store user responses to Firebase only.
                            let viewController = MFMailComposeViewController()
                            viewController.setToRecipients([email])
                            viewController.setSubject("Questions were answered")
                            viewController.setMessageBody("Here are my answers", isHTML: false)
                            self.present(viewController, animated: true, completion: nil)
                            
                        })
                    })
                    //end of homework questions, homework response task.
                }   //system: 
                        //1) loads questions from firebase
                        //2) Stores the users answers in our preferred section in Firebase (i.e. underneath the 'User'
                        //3) Checks which group the user belongs to, and if they belong to a group, sends an e-mail to their group facilitaor (as found on Firebase).

            }
                return cell
    
        }
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(260)
    }
    
    //save the user answer in a variable, to present again, once the user exits the app.
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? QuestionTableViewCell, let answer = cell.answerTextView.text, answer != "" {
            print("Storing the answer \(answer)" )
            self.answers[indexPath.row] = answer
        }
    }
}
