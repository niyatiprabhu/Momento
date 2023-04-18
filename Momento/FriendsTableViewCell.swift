//
//  File.swift
//  Momento
//
//  Created by Niyati Prabhu on 4/6/23.
//

import Foundation
import UIKit
import FirebaseStorage

class FriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    static let identifier = "FriendsTableViewCell"
    private let storage = Storage.storage().reference()
    
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
    }
    
    func configure(with user: User) {
        // TODO: change later to get author image
        setPfpImage(uid: user.uid)
        nameLabel.text = (user.name)
        usernameLabel.text = "@\(user.username)"
    }
    
    func setPfpImage(uid: String) {
        profilePic.image = UIImage(named: "pfpPlaceholder")
        storage.child("pfps/\(uid).jpg").getData(maxSize: 1 * 1024 * 1024, completion: { (data, err) in
            if err != nil {
                self.profilePic.image = UIImage(named: "profilepic")
                print("could not get pfp or none exists for this user")
            } else {
                guard let data = data else {
                    print("error getting pfp data")
                    return
                }
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self.profilePic.image = image
                }
            }
        })
    }
}
