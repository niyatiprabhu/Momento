//
//  LoginViewController.swift
//  Momento
//
//  Created by jasmine wang on 3/2/23.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.isSecureTextEntry = true
        Auth.auth().addStateDidChangeListener() {
            auth, user in
            if user != nil {
                HealthKitManager.shared.authorizeHealthKit { (success, error) in
                    if success {
                        HealthKitManager.shared.getStepsCount { (steps, error) in
                            if let steps = steps {
                                GlobalVariables.globalStepCount = "\(steps)"
                                print("Steps count: \(steps)")
                            } else if let error = error {
                                print("Error: \(error.localizedDescription)")
                            }
                        }
                    } else if let error = error {
                        print("Error: \(error.localizedDescription)")
                    }
                }
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
                self.emailField.text = nil
                self.passwordField.text = nil
                
                
            }
        }
    }
    
    // MARK: - Navigation
    @IBAction func loginButtonPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) {
            authResult, error in if let error = error as NSError? {
                self.errorMessage.text = "\(error.localizedDescription)"
            }
        }
    }
    

}
