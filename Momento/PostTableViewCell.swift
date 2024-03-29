//
//  PostTableViewCell.swift
//  Momento
//
//  Created by jasmine wang on 3/6/23.
//

import UIKit
import HealthKit
import FirebaseStorage

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var promptLabel: UILabel!
    @IBOutlet var responseLabel: UILabel!
    @IBOutlet var bottomContainerView: UIView!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var postLikes: UILabel!
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var heart: UIImageView!
    @IBOutlet weak var shoes: UIImageView!
    @IBOutlet weak var likeView: UIImageView!
    
    var isLiked = false
    static let identifier = "PostTableViewCell"
    private let storage = Storage.storage().reference()
    
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
    
    func setPfpImage(uid: String) {
        userImageView.image = UIImage(named: "pfpPlaceholder")
        storage.child("pfps/\(uid).jpg").getData(maxSize: 1 * 1024 * 1024, completion: { (data, err) in
            if err != nil {
                self.userImageView.image = UIImage(named: "profilepic")
                print("could not get pfp or none exists for this user")
            } else {
                guard let data = data else {
                    print("error getting pfp data")
                    return
                }
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self.userImageView.image = image
                }
            }
        })
    }
    
    func configure(with post: JournalEntry) {
        // get author image
        setPfpImage(uid: post.authorID)
        
        postImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        tapGesture.numberOfTapsRequired = 2
        postImageView.addGestureRecognizer(tapGesture)
        
        heart.alpha = 0
        promptLabel.text = post.prompt
        responseLabel.text = post.response
        bottomContainerView.backgroundColor = post.color
        moodLabel.text = post.mood
        dateLabel.text = JournalEntry.getDateString(date: post.date)
        stepsLabel.text = post.getFormattedSteps()
        dateLabel.textColor = post.darkenColor(percentage: 0.3)
        let textColor: UIColor = post.color.isLight ? .black : .white
        let tintColor = textColor.withAlphaComponent(0.6)
        promptLabel.textColor = textColor
        responseLabel.textColor = textColor
        stepsLabel.textColor = tintColor
        shoes.tintColor = tintColor
        
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
    }

    // double tap to like
    @objc func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        if !isLiked {
            // animate like
            isLiked = true
            likeView.image = UIImage(systemName: "heart.fill")
            heart.alpha = 1
            UIView.animate(withDuration: 0.5, animations: {
                self.heart.alpha = 0
                self.heart.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }) { _ in
                self.heart.alpha = 0
            }
        } else {
            // dislike
            likeView.image = UIImage(systemName: "heart")
            isLiked = false
        }
    }
    
}
