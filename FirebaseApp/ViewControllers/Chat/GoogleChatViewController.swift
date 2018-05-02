//
//  GoogleChatViewController.swift
//  FirebaseApp
//
//  Created by Funke Sowole on 25/03/2018.
//  Copyright © 2018 Funke Sowole. All rights reserved.
//
// Quick and fully functional chat, which
    //Allows the user to interact with the group facilitaor, and chat to other members of their griup via the google groups feature.
    //The parent must be added by their group facilitaor before they can view the content, and contribute
    //The user must login with an e-mail account to use this service
    //More information about google groups: https://www.lynda.com/Groups-tutorials/Exploring-interface-your-groups/196646/372872-4.html?autoplay=true.
    //Groups added/created manually from Google Groups page.

import Foundation
import UIKit
import Firebase

class GoogleChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView:UITableView!

    //var weeks used by "number of section" method to count show many section to split into.
    var groups = ["Camden EPEC", "Greenwich EPEC", "Lambeth EPEC", "Lewisham EPEC", "Southwark EPEC", "Westminster EPEC"] // Cells -> The Borough Groups
    
    var groupsUrl = ["https://groups.google.com/d/forum/camden-epec",
                     "https://groups.google.com/d/forum/greenwich-epec",
                     "https://groups.google.com/forum/#!forum/lambeth-epec",
                     "https://groups.google.com/forum/#!forum/lewisham-epec",
                     "https://groups.google.com/forum/#!forum/southwark-epec",
                     "https://groups.google.com/forum/#!forum/westmister-epec"
                    ]
                            //links to the local group chat (google groups)
    
    var contactFacilUrl = ["https://groups.google.com/forum/#!contactowner/camden-epec/",
                        "https://groups.google.com/forum/#!contactowner/greenwich-epec/",
                        "https://groups.google.com/forum/#!contactowner/lambeth-epec/",
                        "https://groups.google.com/forum/#!contactowner/lewisham-epec/",
                        "https://groups.google.com/forum/#!contactowner/southwark-epec/",
                        "https://groups.google.com/forum/#!contactowner/westmister-epec/"
                    ]
    
                            //links to the facilitator chat (private e-mail message) (google groups)
    
    override func viewDidLoad() {
        
        //set up the table for the chat on load
        
                //i.e. NAME OF GROUP
                        //Speak to Facilitator
                        //Speak to Facilitator
        
        super.viewDidLoad()
        //print("Course View Controller")
        tableView = UITableView(frame: view.bounds, style: .plain)
        
        let cellNib = UINib(nibName: "GroupTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "groupCell")
        tableView.backgroundColor = UIColor(white: 0.40,alpha:1.0)
        view.addSubview(tableView)
        
        var layoutGuide:UILayoutGuide!
        
        if #available(iOS 11.0, *) {
            layoutGuide = view.safeAreaLayoutGuide
        } else {
            // Fallback on earlier versions
            layoutGuide = view.layoutMarginsGuide
        }
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
    }
    
    //if the user does not belong to a group, show an error message!
        //pop-up does not appear if the user belongs to a group.
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        Database.database().reference().child("Users").child(userId).observeSingleEvent(of: DataEventType.value, with: { (snapShot) in
            //            print(snapShot.value ?? )
            guard let dictionary = snapShot.value as? [String: Any], let _ = dictionary["group"] as? String else {
                let alertController = UIAlertController(title: "No group", message: "You don't have an assigned group. Please set it on your profile.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    self.tabBarController?.selectedIndex = 3
                })
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
                return      //close pop-up window for users with no group
            }
        
        }, withCancel: nil)
    }
    //number of cells to diplay == number of groups speicifed above. (manually)
        //The user has to manually add a group on google, so could update the code on line 23, and 32 to add more users.
    func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }
    
    //how to ensure that "Questionnaire" appears in week 1 & 8 only.
    //i.e. could display inside the "Exercises". Tab.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 // Each group runs 1 session only. (for now)
            //code below is ready to support 2 or 3 sessions per borough. (i.e. if westminster has 3 seperate sessions)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.groups[section]
    }
    
    //display the handouts, homework questions, and bonus questions in their cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "subtitleCell") //as! WeekTableViewCell
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "subtitleCell")
        }
        
        
        //determine which cell the user selected.
        let row = indexPath.row
        //The user has option to:
            //1) Speak on Group Chat
            //2) Speak to Facilator Privately.
        
        if row == 0 {
            cell?.textLabel?.text = "Community Group Chat"
        }else if row == 1 {
            cell?.textLabel?.text = "Speak to Facilitator"
        }
        return cell!
    }
    
    //Here load the PDF handouts from Firebase, in a WebView.
    //Check which row the user selected.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Speak to group chat
        if indexPath.row == 0 {
            _ = URL(string: groupsUrl[indexPath.section])!
            
            //open in web view.
            let webViewController = self.storyboard?.instantiateViewController(withIdentifier: "webviewcontroller") as! WebViewController
            webViewController.url = groupsUrl[indexPath.section]
            self.navigationController?.pushViewController(webViewController, animated: true)

        //Speak to Facil Privately
        } else if indexPath.row == 1 {
            
            //open in web view
            let contactUrl = URL(string: contactFacilUrl[indexPath.section])!
        
            let webViewController = self.storyboard?.instantiateViewController(withIdentifier: "webviewcontroller") as! WebViewController
            webViewController.url = contactFacilUrl[indexPath.section]
            self.navigationController?.pushViewController(webViewController, animated: true)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? QuestionViewController,
            let indexPath = self.tableView.indexPathForSelectedRow {
            viewController.weekNumber = indexPath.section + 1
        }
    }
}
