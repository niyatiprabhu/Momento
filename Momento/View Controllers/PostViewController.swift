//
//  PostViewController.swift
//  Momento
//
//  Created by jasmine wang on 3/5/23.
//

import UIKit
import FirebaseAuth

class PostViewController: UIViewController {

    var entry: JournalEntry!

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postBackground: UIView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var responseLabel: UILabel!
    @IBOutlet weak var moodLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = JournalEntry.getDateString(date: entry.date)
        postBackground.backgroundColor = entry.color
        setImage(from: URL(string: entry.photoURL)!)
        promptLabel.text = entry.prompt
        responseLabel.text = entry.response
        moodLabel.text = entry.mood
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

}
