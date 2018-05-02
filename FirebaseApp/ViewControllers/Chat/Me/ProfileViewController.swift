//
//  ProfileViewController.swift
//  FirebaseApp
//
//  Created by Funke Sowole on 16/03/2018.
//  Copyright © 2018 Funke Sowole. All rights reserved.
//  User update which group they belong to using the picker view/drop down on the me page
//  Helpful advice given if the user does not know which group they belongs to
//  The group selected relates to the Homework tasks response.

import UIKit
import Firebase

class ProfileViewController: UIViewController, UITextFieldDelegate {
    
    //-----for groups-----
    @IBOutlet weak var groupPickerView: UIPickerView!

    lazy var groups = ["Group A, Group B"] //default. overwites with Firebase data

    override func viewDidLoad() {
        super.viewDidLoad()

        //call observer to check which group the user belongs to.
        observeGroups()
        
    }
    
   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //determine which group the user belongs to.
    /*
        reads the list of available groups from firebase.
     */
    func observeGroups() {
        
        let groupsRef = Database.database().reference().child("/User groups")   //read groups from firebase.
    
        groupsRef.observe(.value, with: { snapshot in
            
            var tempGroups = [String]()
            var groupNumber = 0     //indexing the current group, so the picker knows which group is selected.
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                let dict = childSnapshot.key as? String {
                    
                    tempGroups.append(dict)
                    let currentGroupNumber = groupNumber    //match the user selected index, with the name of the group from firebase.
                
                }
                self.groups = tempGroups    //store the curren user group
                self.groupPickerView.reloadAllComponents()
            }
            
        })
    }
    
    @IBAction func clickSave(_ sender: Any) {       //function for "save" label. Call the function below
        self.saveProfile { (err) in
            self.navigationController?.popViewController(animated: true)
        }
    }
    /*
        Before saving the user group
            1) Verify who is the current user
            2) Locate the user in the Firebase database
            3) Check which group the user selected they belong to
            4) Update this selection in Fireabase
     */
    func saveProfile(completion: @escaping ((_ success:Bool)->())) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }    // 1) Verify user
        print("My user Id: \(uid)")
        let databaseRef = Database.database().reference().child("Users/\(uid)") //2) Locate the user in the Firebase database
        let selectedRow = self.groupPickerView.selectedRow(inComponent: 0)   //3) Check which group the user select
        
        databaseRef.observeSingleEvent(of: .value) { (snapshot) in
            guard let user = snapshot.value as? [String: Any] else {
                return          //4) Update this user group selection in firebase, under "Users" tree in Firebase.
            }
            var userObject = user
            userObject["group"] = self.groups[selectedRow]      //store the users group.
            databaseRef.setValue(userObject) { error, ref in
                completion(error == nil)
            }
        }
    }
}

//picker view extension
extension ProfileViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.groups.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.groups[row]
    }

}
