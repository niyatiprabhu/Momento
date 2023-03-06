//
//  HomeAfterPostedViewController.swift
//  Momento
//
//  Created by jasmine wang on 3/6/23.
//

import UIKit

class HomeAfterPostedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if !GlobalVariables.myPosts.isEmpty {
            let newPost = GlobalVariables.myPosts[GlobalVariables.myPosts.endIndex - 1]
            print(newPost.text + " " + newPost.date.description + " " + newPost.author.name)
        } else {
            print("myPosts is empty")
        }
        
    }

}
