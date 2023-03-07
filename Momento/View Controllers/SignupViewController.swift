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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
