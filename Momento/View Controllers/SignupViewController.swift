//
//  SignupViewController.swift
//  Momento
//
//  Created by jasmine wang on 3/7/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField:UITextField!
    @IBOutlet weak var usernameField:UITextField!
    @IBOutlet weak var passwordField:UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //set delegates
        emailField.delegate = self
        usernameField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        
        //secure password texr entries
        passwordField.isSecureTextEntry = true
        confirmPasswordField.isSecureTextEntry = true
        
        Auth.auth().addStateDidChangeListener() {
            auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "SignupSegue", sender: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.nameField.text = nil
        self.emailField.text = nil
        self.passwordField.text = nil
        self.usernameField.text = nil
        self.confirmPasswordField.text = nil
    }

    @IBAction func submitButtonPressed(_ sender: Any) {
        
        // TODO: add field checks to make sure all fields are filled in
        // create a new user
        
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { authResult, error in
            
            guard let user = authResult?.user, error == nil else {
                // print error message
                print("\(error!.localizedDescription)")
                return
            }
            
            // create user object & store in Firebase
            let newUser = User(name: self.nameField.text!, username: self.usernameField.text!, email: user.email!, uid: user.uid)
            print(newUser.dictionary)
            
            let db = Firestore.firestore()
            db.collection("users").document(user.uid).setData(newUser.dictionary) {
                error in
                if let error = error {
                    print("error adding user: \(error.localizedDescription)")
                } else {
                    print("user added successfully!")
                }
            }
            
        }
    }
    
    
    // MARK: - Navigation
    @IBAction func loginBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // Called when 'return' key pressed
      func textFieldShouldReturn(_ textField:UITextField) -> Bool {
          textField.resignFirstResponder()
          return true
      }
      
      // Called when the user clicks on the view outside of the UITextField
      override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          self.view.endEditing(true)
      }
}
