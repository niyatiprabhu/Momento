//
//  HomeAfterPostedViewController.swift
//  Momento
//
//  Created by jasmine wang on 3/6/23.
//

import UIKit

class HomeAfterPostedViewController: UIViewController, PostFiller {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postBackground: UIView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var responseLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !GlobalVariables.myPosts.isEmpty {
            let newPost = GlobalVariables.myPosts[GlobalVariables.myPosts.endIndex - 1]
            print(newPost.response + " " + newPost.date.description + " " + newPost.author.name)
        } else {
            print("myPosts is empty")
        }
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: Date.now)
        var date = calendar.date(from: dateComponents)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        if let d = date {
            let dateString = dateFormatter.string(from: d)
            dateLabel.text = dateString
        }
    }
    
    func fillPost(entry: JournalEntry) {
        postBackground.backgroundColor = entry.color
        postImageView.image = entry.photo
        promptLabel.text = entry.prompt
        responseLabel.text = entry.response
    }

}
