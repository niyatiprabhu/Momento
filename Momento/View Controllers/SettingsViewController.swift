//
//  SettingsViewController.swift
//  Momento
//
//  Created by jasmine wang on 3/5/23.
//

import UIKit
import FirebaseAuth
import Firebase
import UserNotifications

class SettingsViewController: UIViewController {

    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var newPasswordLabel: UILabel!
    @IBOutlet weak var currentPasswordLabel: UILabel!
    @IBOutlet weak var currentPasswordField: UITextField!
    @IBOutlet weak var saveChangesButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var currentEmailLabel: UILabel!
    @IBOutlet weak var currentUsernameLabel: UILabel!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBAction func editPressed(_ sender: Any) {
        currentEmailLabel.isHidden = true
        currentUsernameLabel.isHidden = true
        usernameField.isHidden = false
        emailField.isHidden = false
        currentPasswordLabel.isHidden = false
        newPasswordField.isHidden = false
        newPasswordLabel.isHidden = false
        saveChangesButton.isHidden = false
        currentPasswordField.isHidden = false
        currentPasswordLabel.isHidden = false
        newPasswordField.isSecureTextEntry = true
    }
    
    @IBAction func saveChangesPressed(_ sender: Any) {
        let credential = EmailAuthProvider.credential(withEmail: (Auth.auth().currentUser?.email)!, password: currentPasswordField.text!)
        Auth.auth().currentUser?.reauthenticate(with: credential) { (result, error) in
            if let error = error {
                print("Error reauthenticating user: \(error.localizedDescription)")
                return
            }
            if (self.newPasswordField.text != "") {
                let newPassword = self.newPasswordField.text!
                Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
                    if let error = error {
                        print("Error updating password: \(error.localizedDescription)")
                        self.statusLabel.text = "Error updating password"
                    } else {
                        print("Password updated successfully")
                    }
                }
            }
            
            if (self.emailField.text != "") {
                let newEmail = self.emailField.text!
                Auth.auth().currentUser?.updateEmail(to: newEmail) { error in
                    if let error = error {
                        print("Error updating email address: \(error.localizedDescription)")
                        self.statusLabel.text = "Error updating password"
                    } else {
                        print("Email address updated successfully")
                    }
                }
            }
            if (self.usernameField.text != "") {
                let uid = Auth.auth().currentUser?.uid
                let db = Firestore.firestore()
                let docRef = db.collection("users").document(uid!)
                docRef.updateData(["username": self.usernameField.text!]) { error in
                    if let error = error {
                        print("Error updating username: \(error.localizedDescription)")
                        self.statusLabel.text = "Error updating username"
                    } else {
                        print("Username updated successfully")
                    }
                }
            }
            if self.statusLabel.text == "" {
                self.statusLabel.text = "Successfully Updated"
            }
            
            
        }
    }
    
    
    @IBAction func segmentChanged(_ sender: Any) {
        switch segControl.selectedSegmentIndex {
            case 0:
                self.scheduleRandomNotification()
            case 1:
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    if settings.authorizationStatus == .authorized {
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    }
                }
            default:
                break
        }
    }
    
    func scheduleRandomNotification() {
        // Set the notification content
        let content = UNMutableNotificationContent()
        content.title = "Time to make a Momento"
        content.body = "Your daily reminder to make a journal entry today"
        
        // Set a random time for the notification
        let randomHour = Int.random(in: 0..<24)
        let randomMinute = Int.random(in: 0..<60)
        let dateComponents = DateComponents(hour: randomHour, minute: randomMinute)
        
        // Create the notification trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // Create the notification request
        let request = UNNotificationRequest(identifier: "randomNotification", content: content, trigger: trigger)
        
        // Add the request to the notification center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled at \(randomHour):\(randomMinute)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segControl.selectedSegmentIndex = 0
        saveChangesButton.isHidden = true
        emailField.isHidden = true
        newPasswordField.isHidden = true
        newPasswordLabel.isHidden = true
        usernameField.isHidden = true
        currentPasswordField.isHidden = true
        currentPasswordLabel.isHidden = true
        statusLabel.text = ""
        let uid = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(uid!)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let username = document["username"] as? String
                self.currentUsernameLabel.text = username
            } else {
                self.currentUsernameLabel.text = "Could not get username"
            }
        }
        let email = Auth.auth().currentUser?.email
        currentEmailLabel.text = email
        self.scheduleRandomNotification()
    }
    

    // MARK: - Navigation
    @IBAction func logoutBtnPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "LogoutSegue", sender: nil)
        } catch {
            print("logout error")
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: false)
    }
}
