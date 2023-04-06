//
//  File.swift
//  Momento
//
//  Created by Niyati Prabhu on 4/6/23.
//

import Foundation
import UIKit

class FriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    static let identifier = "FriendsTableViewCell"
    
    // to register cell with table view more easily
    static func nib() -> UINib {
        return UINib(nibName: "FriendsTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(with user: User) {
        // TODO: change later to get author image
        profilePic.image = UIImage(named: "pfp1")
        nameLabel.text = (user.name)
        usernameLabel.text = "@\(user.username)"
        
    }
}
