//
//  HomeViewController.swift
//  FirebaseApp
//
//  Created by Jeongho Suh & Funke Sowole 01/03/2018.
//  Copyright © 2018 Jeongho Suh & Funke Sowole. All rights reserved.
//
// Presents the Main course page as a TableViewCell (with the Handout, HW Tasks, and Measures (Bonus Activity) presented as many times as needed.
// Stores the URL for the handouts, and the measures (i.e. bonus acitivity) from Firebase.

import Foundation
import UIKit
import Firebase

class CourseViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView:UITableView!

    var weeks = ["Week 1", "Week 2", "Week 3", "Week 4", "Week 5", "Week 6", "Week 7", "Week 8"] // Cells -> Sections
    
    var handoutUrl = ["https://firebasestorage.googleapis.com/v0/b/beingaparent-563cd.appspot.com/o/week1.pdf?alt=media&token=4b83574d-61bb-4723-9e26-9c5c684adfcc",
                   "https://firebasestorage.googleapis.com/v0/b/beingaparent-563cd.appspot.com/o/week2.pdf?alt=media&token=d639cb31-6169-409f-9935-8425fa20fa38",
                   "https://firebasestorage.googleapis.com/v0/b/beingaparent-563cd.appspot.com/o/week3.pdf?alt=media&token=07105675-2ebb-4522-bf59-9abc3d87252d",
                   "https://firebasestorage.googleapis.com/v0/b/beingaparent-563cd.appspot.com/o/week4.pdf?alt=media&token=c0f2674b-bdb0-45bc-9eac-746c0f8cf2f9",
                   "https://firebasestorage.googleapis.com/v0/b/beingaparent-563cd.appspot.com/o/week5.pdf?alt=media&token=e05a6aee-ad00-4882-b9ba-ca1df62adbc4",
                   "https://firebasestorage.googleapis.com/v0/b/beingaparent-563cd.appspot.com/o/week6.pdf?alt=media&token=bbd244d2-ccd6-4e13-b1de-c083d2071644",
                   "https://firebasestorage.googleapis.com/v0/b/beingaparent-563cd.appspot.com/o/week7.pdf?alt=media&token=a8b1ce13-ba68-4bbc-af4e-524a8e8f928e",
                   "https://firebasestorage.googleapis.com/v0/b/beingaparent-563cd.appspot.com/o/week8.pdf?alt=media&token=7548ad4d-1ed5-4c4f-9c4c-bdbc74f3ba39"]
    
    var bonusUrl = ["https://docs.google.com/forms/d/1ntotnG1klkPF0bP0l3XYiDc6eM4PjtD3-YnzA4z8ZDM/viewform",
                    "https://docs.google.com/forms/d/e/1FAIpQLSeIlLij88E_yNSHWbWqTO7aID8x_5fuBw9VNgY5re392rdy6A/viewform",
                    "https://docs.google.com/forms/d/1gXSlJ8b5F7GgOavKbAT1sg_R22WVEI8BZe8TzyYSbeY/viewform",
                    "https://docs.google.com/forms/d/e/1FAIpQLSfXhnrgVnb3v9cssSWaU40L_mOTXpUL7CHxe-W1f9Ma2GPthQ/viewform",
                    "https://docs.google.com/forms/d/e/1FAIpQLSdBC91TZeQ7VkF9t41vcYT3vVhNIUdwz-A7gnhgR8qbOG5qPw/viewform",
                    "https://drive.google.com/open?id=1ZgzkKqSqHABjMq9Y6Q_0G1oKJw8_RbuN",
                    "https://twitter.com/CPCS_EPEC",
                    "https://docs.google.com/forms/d/e/1FAIpQLSeXMwAQRhpgVDmHS-dVRBQfJ_VH8_2Bof7cMshVGydaT7dIrw/viewform"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("Course View Controller")
        tableView = UITableView(frame: view.bounds, style: .plain)
        
        let cellNib = UINib(nibName: "WeekTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "weekCell")
        tableView.backgroundColor = UIColor(white: 0.90,alpha:1.0)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return weeks.count
    }
    
    //how to ensure that "Questionnaire" appears in week 1 & 8 only.
    //i.e. could display inside the "Exercises". Tab.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // Handouts, exercises, questionaire
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.weeks[section]
    }
    
    //display the handouts, homework questions, and bonus questions in their cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "subtitleCell") //as! WeekTableViewCell
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "subtitleCell")
        }
        //cell.set(post: posts[indexPath.row])
        let row = indexPath.row
        if row == 0 {
            cell?.textLabel?.text = "Handouts"
        }else if row == 1 {
            cell?.textLabel?.text = "Exercises" //the tasks would contain 
        } else {
            cell?.textLabel?.text = "Bonus Activity" //the tasks would contain
        }
        return cell!
    }
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(120)
    }
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row Week \(indexPath.section + 1)")
        
        if indexPath.row == 0 {
            //1) Displays the PDF handouts in embedded webpage
            // week 1-8 -> handouts
            let url = URL(string: handoutUrl[indexPath.section])!
            
            let webViewController = self.storyboard?.instantiateViewController(withIdentifier: "webviewcontroller") as! WebViewController
            webViewController.url = handoutUrl[indexPath.section]
            self.navigationController?.pushViewController(webViewController, animated: true)
            //performSegue(withIdentifier: "showHandouts", sender: self)
        } else if indexPath.row == 1 {
            //2) display's homework questions pulled from the Firebase database.
            // week 1-8 -> Exercises
            performSegue(withIdentifier: "showQuestions", sender: self)
            
        } else {
            // week 1-8 -> Bonus Activity
            let bUrl = URL(string: bonusUrl[indexPath.section])!
        
            let webViewController = self.storyboard?.instantiateViewController(withIdentifier: "webviewcontroller") as! WebViewController
            webViewController.url = bonusUrl[indexPath.section]
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


