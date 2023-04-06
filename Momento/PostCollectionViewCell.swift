//
//  PostCollectionViewCell.swift
//  Momento
//
//  Created by Shadin Hussein on 4/5/23.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    
    var post: JournalEntry! {
        didSet {
            updateUI()
        }
    }
   
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postResponse: UILabel!
    @IBOutlet weak var stepCountLabel: UILabel!
    @IBOutlet weak var moodLabel: UILabel!
    
    func setImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.postImage.image = UIImage(data: data)
                }
            }
        }.resume()
    }
    
    func updateUI(){
        setImage(from: URL(string: post.photoURL)!)
        postResponse.text = post.response
        moodLabel.text = post.mood
        stepCountLabel.text = "300"
        self.backgroundColor = post.color
        
    }
}
