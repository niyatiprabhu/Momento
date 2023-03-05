//
//  CreateEntryViewController.swift
//  Momento
//
//  Created by jasmine wang on 3/5/23.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    
    @IBOutlet weak var textResponseField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func onPostPressed(_ sender: Any) {
        let calendar = Calendar.current
        let today = calendar.dateComponents([.year, .month, .day], from: Date.now)
        var newPost = JournalEntry(photoUpload: UIImage(), textResponse: textResponseField.text!, todayDate: today, user: GlobalVariables.currentUser)
        GlobalVariables.myPosts.append(newPost)
        GlobalVariables.allPosts.append(newPost)
        // display the new post
        performSegue(withIdentifier: "EntryJustPosted", sender: self)
    }
}
