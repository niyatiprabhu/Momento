//
//  SignupViewController.swift
//  Momento
//
//  Created by jasmine wang on 3/7/23.
//

import UIKit
import FirebaseAuth

class SignupViewController: UIViewController {
    
    @IBOutlet weak var emailField:UITextField!
    @IBOutlet weak var usernameField:UITextField!
    @IBOutlet weak var passwordField:UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.isSecureTextEntry = true
        confirmPasswordField.isSecureTextEntry = true
        Auth.auth().addStateDidChangeListener() {
            auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "SignupSegue", sender: nil)
                self.emailField.text = nil
                self.passwordField.text = nil
                self.usernameField.text = nil
                self.confirmPasswordField.text = nil
            }
        }
    }
    

    @IBAction func submitButtonPressed(_ sender: Any) {
        // create a new user
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) {
            authResult, error in if let error = error as NSError? {
                // print error message
                print("\(error.localizedDescription)")
            }
        }
    }
    
    
    // MARK: - Navigation
    @IBAction func loginBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
