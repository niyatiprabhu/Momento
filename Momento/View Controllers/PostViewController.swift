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
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var shoes: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = JournalEntry.getDateString(date: entry.date)
        postBackground.backgroundColor = entry.color
        let textColor: UIColor = entry.color.isLight ? .black : .white
        let tintColor = textColor.withAlphaComponent(0.6)
        promptLabel.textColor = textColor
        responseLabel.textColor = textColor
        stepsLabel.textColor = tintColor
        shoes.tintColor = tintColor
        setImage(from: URL(string: entry.photoURL)!)
        promptLabel.text = entry.prompt
        responseLabel.text = entry.response
        moodLabel.text = entry.mood
        stepsLabel.text = entry.getFormattedSteps()
    }
    
    // set post image
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
