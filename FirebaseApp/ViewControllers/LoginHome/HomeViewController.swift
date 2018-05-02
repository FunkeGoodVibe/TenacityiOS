//
//  HomeViewController.swift
//  FirebaseApp
//
//  Created by George Thornton & Funke Sowole on 13/03/2018.
//  Copyright © 2018 George Thornton & Funke Sowole. All rights reserved.
//
//  - Basic code for the homepage.
//  Allows the user to logout from the homepage.

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleLogout(_ sender: Any) {
        try! Auth.auth().signOut()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
