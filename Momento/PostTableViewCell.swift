//
//  PostTableViewCell.swift
//  Momento
//
//  Created by jasmine wang on 3/6/23.
//

import UIKit
import HealthKit

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
    
    
    
    
    static let identifier = "PostTableViewCell"
    
    // to register cell with table view more easily
    static func nib() -> UINib {
        return UINib(nibName: "PostTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with model: JournalEntry) {
//        userImageView.image = model.author.profilePhoto
//        postImageView.image = model.photo
//        usernameLabel.text = model.author.username
//        nameLabel.text = model.author.name
//        promptLabel.text = model.prompt
//        responseLabel.text = model.response
//        bottomContainerView.backgroundColor = model.color
//        stepCount.text = GlobalVariables.globalStepCount
    }
    
    
    
}
