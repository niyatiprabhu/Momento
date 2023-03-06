//
//  HomeAfterPostedViewController.swift
//  Momento
//
//  Created by jasmine wang on 3/6/23.
//

import UIKit

class HomeAfterPostedViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !GlobalVariables.myPosts.isEmpty {
            let newPost = GlobalVariables.myPosts[GlobalVariables.myPosts.endIndex - 1]
            print(newPost.text + " " + newPost.date.description + " " + newPost.author.name)
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

}
