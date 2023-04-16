//
//  PostTableViewCell.swift
//  Momento
//
//  Created by jasmine wang on 3/6/23.
//

import UIKit
import HealthKit
import FirebaseFirestore

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var promptLabel: UILabel!
    @IBOutlet var responseLabel: UILabel!
    @IBOutlet var bottomContainerView: UIView!
    @IBOutlet weak var postLikes: UILabel!
    @IBOutlet weak var stepCount: UILabel!
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!

    
    static let identifier = "PostTableViewCell"
    
    // to register cell with table view more easily
    static func nib() -> UINib {
        return UINib(nibName: "PostTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with post: JournalEntry) {
        // TODO: change later to get author image
        userImageView.image = UIImage(named: "pfp1")
        
        promptLabel.text = post.prompt
        responseLabel.text = post.response
        bottomContainerView.backgroundColor = post.color
        moodLabel.text = post.mood
        dateLabel.text = JournalEntry.getDateString(date: post.date)
        dateLabel.textColor = darkenColor(color: post.color)
        
        // get image from URL
        guard let url = URL(string: post.photoURL) else {
            print("couldn't get photo url")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.postImageView.image = image
            }
            
        })
        
        guard let user = users[post.authorID] else {
            print(users.count)
            print("could not find user in users dictionary")
            return;
        }

        usernameLabel.text = "@\(user.username)"
        nameLabel.text = user.name
        
        task.resume()
//        stepCount.text = GlobalVariables.globalStepCount
    }
    
    func darkenColor(color: UIColor) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        let newBrightness = max(0, brightness - 0.3) // darken by 30%
        return UIColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha)
    }
    
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        if sender.image(for: .normal) == UIImage(systemName: "heart") {
               sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
           } else {
               sender.setImage(UIImage(systemName: "heart"), for: .normal)
           }
    }
        
    
    
}
