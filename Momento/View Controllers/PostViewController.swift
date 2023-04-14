//
//  PostViewController.swift
//  Momento
//
//  Created by jasmine wang on 3/5/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class PostViewController: UIViewController {

    var dateComponents:DateComponents?
    let db = Firestore.firestore()
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postBackground: UIView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var responseLabel: UILabel!
    @IBOutlet weak var moodLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendar = Calendar.current
        guard let components = dateComponents, let date = calendar.date(from: components) else {
            print("error getting date")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let dateString = dateFormatter.string(from: date)
        dateLabel.text = dateString
        
        guard let user = Auth.auth().currentUser else {
            print("could not get current user")
            return
        }
        
        let postsRef = db.collection("posts")
        let query = postsRef.whereField("dateString", isEqualTo: dateString).whereField("authorID", isEqualTo: user.uid)
        
        query.getDocuments(completion: {
            querySnapshot, error in
            if let error = error {
                print("error getting post: \(error)")
            } else {
                let count = querySnapshot!.count
                if count > 0 {
                    if let document = querySnapshot!.documents.first {
                        let post = JournalEntry(dict: document.data())
                        // fill post data
                        self.fillPost(entry: post)
                    } else {
                        print("couldn't find first document")
                    }
                }
            }
        })
        
        
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
    }

}
