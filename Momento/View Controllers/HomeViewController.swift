//
//  HomeViewController.swift
//  Momento
//
//  Created by jasmine wang on 3/2/23.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var subview: UIView!
    
    let beforePostVC = HomeBeforePostingViewController()
    let afterPostVC = HomeAfterPostedViewController()
    
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
        // check if most recent post is the same as today's date
        let calendar = Calendar.current
        let today = calendar.dateComponents([.year, .month, .day], from: Date.now)
        let lastPostIndex = GlobalVariables.myPosts.endIndex - 1
        
        if !GlobalVariables.myPosts.isEmpty {
            let lastPost = GlobalVariables.myPosts[lastPostIndex]
            print("myPosts is not empty!")
            if today == lastPost.date {
                // show afterPostVC
                beforePostVC.view.isHidden = true
                afterPostVC.fillPost(entry: lastPost)
                afterPostVC.view.isHidden = false
            }
        }
    }
    

}
