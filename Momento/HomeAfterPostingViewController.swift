//
//  HomeAfterPostingViewController.swift
//  Momento
//
//  Created by Niyati Prabhu on 3/5/23.
//

import UIKit

class HomeAfterPostingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let newPost = GlobalVariables.allPosts[GlobalVariables.allPosts.endIndex - 1]
        print(newPost.text + " " + newPost.date.description + " " + newPost.author.name)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
