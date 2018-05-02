//
//  LoginViewController.swift
//  CloudFunctions
//
//  Created by Robert Canton on 2017-09-13.
//  Copyright © 2017 Robert Canton. All rights reserved.
//
// Adapted existing code.
// Allow the user to login (connection via the Firebase dataabase)
// Key features
// -> Sets up Login components (I.e. e-mail address / password field / button.)
// -> Relevant help messages if the user inputs incorrect password
// ->

import Foundation
import UIKit
import Firebase

class LoginViewController:UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var dismissButton: UIButton!
    
    var continueButton:RoundedWhiteButton!
    var activityView:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialiseButtons()
        self.initialiseActivityView()
        self.initialiseBackgroundColour()
        self.initialiseUserProperties()
    }
    
    //--------------------------------------------------------------------------------------------start initialistion
    //1) Clean Code function_1 - Set up continue button
    func initialiseButtons() {
        
        //define button dimension which appears when login form loads
        continueButton = RoundedWhiteButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
       // continueButton.setTitleColor(secondaryColor, for: .normal)
        continueButton.setTitle("Continue", for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.bold)
        continueButton.center = CGPoint(x: view.center.x, y: view.frame.height - continueButton.frame.height - 24)
        continueButton.highlightedColor = UIColor(white: 1.0, alpha: 1.0)
        continueButton.defaultColor = UIColor.black
        continueButton.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        continueButton.alpha = 0.5
        view.addSubview(continueButton) //add the button to the login screen
        setContinueButton(enabled: false) //user cannot login on form load (i.e. no username/password inputted)
        
    }
    //Clean Code function_2 - set up activity view
    func initialiseActivityView(){
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        //  The 3 attributes of the variable, activityView, are assigned to the respective objects.
       
        
        
        //activityView.color = secondaryColor
        //  The activityView frame is set to a rectange of width of 50 pixels and height of 50 pixels.
        activityView.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
        activityView.center = continueButton.center
        
        view.addSubview(activityView)   //continue button changes colour if enabled/disabled. Add button colour properties to the login page.
    }
    
    //Clean Code function_3 - set up background colour / gradient
    func initialiseBackgroundColour(){
       // view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        //here
    }
    
    //Clean Code function_4 - set up user properties
    func initialiseUserProperties(){
        
        emailField.delegate = self
        passwordField.delegate = self
        emailField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
     //--------------------------------------------------------------------------------------------end initialistion
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailField.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillAppear), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    /*
     viewWillAppear overides the super classes' instantiation of this function.
     - Parameter animated: determines if the view will appear or not.     */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    /*
     viewWillAppear overdies the super classes' instantiation of this function.
     - Parameter sender: 4$ */
    @IBAction func handleDismissButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    /**
     Adjusts the center of the **continueButton** above the keyboard.
     - Parameter notification: Contains the keyboardFrame info.
     */
    
    @objc func keyboardWillAppear(notification: NSNotification){
        
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        continueButton.center = CGPoint(x: view.center.x,
                                        y: view.frame.height - keyboardFrame.height - 16.0 - continueButton.frame.height / 2)
        activityView.center = continueButton.center
    }
    
    //enables continue if the e-mail & password not empty
    //- Parameter target: The targeted **UITextField**.
    @objc func textFieldChanged(_ target:UITextField) {
        let email = emailField.text
        let password = passwordField.text
        let formFilled = email != nil && email != "" && password != nil && password != ""
        setContinueButton(enabled: formFilled)
    }
    
     // Resigns the target textField and assigns the next textField in the form.
    //i.e. updates based on user input
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case emailField:
            emailField.resignFirstResponder()
            passwordField.becomeFirstResponder()
            break
        case passwordField:
            handleSignIn()
            break
        default:
            break
        }
        return true
    }
    
    /*
     Enables or Disables the **continueButton**.
     */
    func setContinueButton(enabled:Bool) {
        if enabled {
            continueButton.alpha = 1.0
            continueButton.isEnabled = true
        } else {
            continueButton.alpha = 0.5
            continueButton.isEnabled = false
        }
    }
    
    /**
     Gathers the contents of the email and pass textfields and determines whether the email and password of that
     user, are for an existing user and have inputted any text at all or not.
     */
    @objc func handleSignIn() {
        guard let email = emailField.text else { return }
        guard let pass = passwordField.text else { return }
        
        setContinueButton(enabled: false)
        continueButton.setTitle("", for: .normal)
        activityView.startAnimating()
        
        Auth.auth().signIn(withEmail: email, password: pass) { user, error in
            if error == nil && user != nil {
                self.dismiss(animated: false, completion: nil)
            } else {
                print("Please Contact Your Group Faciliator: \(error!.localizedDescription)")
                
                self.resetForm()
            }
        }
    }
    
    /**
     */
    func resetForm() {
        let alert = UIAlertController(title: "Incorrect Password or E-mail. Please Contact Your Group Faciliator", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        setContinueButton(enabled: true)
        continueButton.setTitle("Continue", for: .normal)
        activityView.stopAnimating()
    }
    
}
