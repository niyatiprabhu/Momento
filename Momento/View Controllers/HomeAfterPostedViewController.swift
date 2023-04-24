//
//  HomeAfterPostedViewController.swift
//  Momento
//
//  Created by jasmine wang on 3/6/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import Firebase
import FirebaseFirestore

class HomeAfterPostedViewController: UIViewController, PostFiller {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postBackground: UIView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var responseLabel: UILabel!
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var shoes: UIImageView!
    @IBOutlet weak var stepsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set date
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: Date.now)
        dateLabel.text = JournalEntry.getDateString(date: dateComponents)
    }
    
    func setImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.postImageView.image = UIImage(data: data)
                }
            }
        }.resume()
    }
    
    func fillPost(entry: JournalEntry) {
        postBackground.backgroundColor = entry.color
        setImage(from: URL(string: entry.photoURL)!)
        promptLabel.text = entry.prompt
        responseLabel.text = entry.response
        moodLabel.text = entry.mood
        stepsLabel.text = entry.getFormattedSteps()
        let color = entry.darkenColor(percentage: 0.5)
        stepsLabel.textColor = color
        shoes.tintColor = color
    }

    @IBAction func deleteButtonPressed(_ sender: Any) {
        
        let controller = UIAlertController(
            title: "Are you sure?",
            message: "Deleting this post cannot be undone",
            preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(
            title: "Yes",
            style: .default,
            handler: {_ in self.deleteFirebasePost()}))
        
        controller.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel))
        
        present(controller, animated: true)
        
        
    }
    
    func deleteFirebasePost() {
        let group = DispatchGroup()
        group.enter()
        
        guard let userId = Auth.auth().currentUser?.uid else {
                return
        }
        let db = Firestore.firestore()
        // Create a query that filters the 'posts' collection by the current user's ID, orders the documents by their creation time, and limits the result to one document
        let query = db.collection("posts").whereField("authorID", isEqualTo: userId).order(by: "timestamp", descending: true).limit(to: 1)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    // Delete the most recent document
                    db.collection("posts").document(document.documentID).delete { (error) in
                        if let error = error {
                            print("Error deleting document: \(error)")
                        } else {
                            print("Document successfully deleted")
                        }
                    }
                }
            }
        }
        group.leave()
        
        // show the before posting vc instead now
        let parent = self.parent as! HomeViewController
        parent.afterPostVC.view.isHidden = true
        parent.beforePostVC.view.isHidden = false
    }
}

