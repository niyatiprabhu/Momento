//
//  HomeViewController.swift
//  Momento
//
//  Created by jasmine wang on 3/2/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class HomeViewController: UIViewController {

    @IBOutlet weak var subview: UIView!
    
    let beforePostVC = HomeBeforePostingViewController()
    let afterPostVC = HomeAfterPostedViewController()
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        
        addChild(beforePostVC)
        addChild(afterPostVC)
        
        self.view.addSubview(beforePostVC.view)
        self.view.addSubview(afterPostVC.view)
        
        beforePostVC.didMove(toParent: self)
        afterPostVC.didMove(toParent: self)
        
        beforePostVC.view.frame = subview.bounds
        afterPostVC.view.frame = subview.bounds
        
        afterPostVC.view.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // check if user's most recent post is the same as today's date
        let calendar = Calendar.current
        let today = calendar.dateComponents([.year, .month, .day], from: Date.now)
        let todayString = JournalEntry.getDateString(date: today)
        
        guard let user = Auth.auth().currentUser else {
            print("could not get current user")
            return
        }
        
        let postsRef = db.collection("posts")
        let query = postsRef.whereField("dateString", isEqualTo: todayString).whereField("authorID", isEqualTo: user.uid)
        
        query.getDocuments(completion: {
            querySnapshot, error in
            if let error = error {
                print("error getting post: \(error)")
            } else {
                let count = querySnapshot!.count
                if count > 0 {
                    if let document = querySnapshot!.documents.first {
                        let post = JournalEntry(dict: document.data())
                        self.showAfterPostVC(post: post)
                    } else {
                        print("couldn't find first document")
                    }
                }
            }
        })
        
    }
    
    func showAfterPostVC(post: JournalEntry) {
        beforePostVC.view.isHidden = true
        afterPostVC.fillPost(entry: post)
        afterPostVC.view.isHidden = false
    }
    

}
