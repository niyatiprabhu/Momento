//
//  ProfileViewController.swift
//  Momento
//
//  Created by jasmine wang on 3/5/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController {
    
    let postSegueIdentifier = "PostSegueIdentifier"
    var entryToSend:JournalEntry?
    var myPosts = Dictionary<String, JournalEntry>()
    let db = Firestore.firestore()
    var calendar: UICalendarView?
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pfp: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCalendar()
        
        guard let user = Auth.auth().currentUser else {
            print("could not get current user")
            return
        }
        
        
        
        getPosts(user: user)
    }
    
    func createCalendar() {
        let calendarView = UICalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.calendar = .current
        calendarView.locale = .current
        calendarView.fontDesign = .rounded
        calendarView.delegate = self
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            calendarView.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 15),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
        
        calendar = calendarView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == postSegueIdentifier, let nextVC = segue.destination as? PostViewController {
            nextVC.entry = entryToSend!
        }
    }
    
    func getPosts(user: FirebaseAuth.User) {
        db.collection("posts").whereField("authorID", isEqualTo: user.uid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let entry = JournalEntry(dict: document.data())
                    let dateString = JournalEntry.getDateString(date: entry.date)
                    self.myPosts[dateString] = entry
                    guard let calendar = self.calendar else {
                        print("no calendar")
                        return
                    }
                    calendar.reloadDecorations(forDateComponents: [entry.date], animated: false)
                }
            }
        }
    }
    
}

extension ProfileViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        if dateComponents != nil {
            let dateString = JournalEntry.getDateString(date: dateComponents!)
            if let entry = myPosts[dateString] {
                entryToSend = entry
                performSegue(withIdentifier: postSegueIdentifier, sender: nil)
            } else {
                // create alert that says no post that day
                let alertController = UIAlertController(title: "No Entry", message: "You didn't make a post on this day 😢", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                present(alertController, animated: true)
            }
        }
    }
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        
        // decorate if there's a post with this date
        let dateString = JournalEntry.getDateString(date: dateComponents)
        if myPosts.contains(where: {$0.key == dateString}) {
            return UICalendarView.Decoration.default(color: .systemTeal, size: .large)
        }
        return nil

    }
}
