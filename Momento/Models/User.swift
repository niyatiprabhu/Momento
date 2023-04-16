//
//  User.swift
//  Momento
//
//  Created by Niyati Prabhu on 3/5/23.
//

import Foundation
import UIKit

class User {
    var name: String
    var username: String
    var email: String
    var profilePhoto: UIImage!
    var pfpLink: String?
    var stepCount: String
    var uid: String
    
    // TODO: GET RID OF THIS LATER
    init(myName: String, myUsername: String, myEmail: String, myPass: String, myPhoto: UIImage, mySteps: String ) {
        name = myName
        username = myUsername
        email = myEmail
        profilePhoto = myPhoto
        stepCount = mySteps
        uid = ""
    }
    
    init(name: String, username: String, email: String, uid: String) {
        self.name = name
        self.username = username
        self.email = email
        self.profilePhoto = UIImage(named: "pfp1")
        self.stepCount = ""
        self.uid = uid
        print(username, self.username)
        print(name, self.name)
    }
    
    init?(dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String,
              let username = dictionary["username"] as? String,
              let email = dictionary["email"] as? String,
              let uid = dictionary["uid"] as? String
        else {
            return nil
        }
        
        self.name = name
        self.username = username
        self.email = email
        self.stepCount = ""
        self.uid = uid
        self.profilePhoto = UIImage(named: "pfp1")
        
    }
    
    var dictionary: [String: Any] {
        return [
            "name": self.name,
            "username": self.username,
            "email": self.email,
            "uid": self.uid
        ]
    }
}
