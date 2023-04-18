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
    var pfpLink: String?
    var uid: String
    var friends: [String]
    
    init(name: String, username: String, email: String, uid: String) {
        self.name = name
        self.username = username
        self.email = email
        self.uid = uid
        self.friends = []
        print(username, self.username)
        print(name, self.name)
    }
    
    init?(dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String,
              let username = dictionary["username"] as? String,
              let email = dictionary["email"] as? String,
              let uid = dictionary["uid"] as? String,
              let friends = dictionary["friends"] as? [String]
        else {
            print("FAILED TO CREATE USER FROM DICTIONARY")
            return nil
        }
        self.name = name
        self.username = username
        self.email = email
        self.uid = uid
        self.friends = friends
    }
    
    var dictionary: [String: Any] {
        return [
            "name": self.name,
            "username": self.username,
            "email": self.email,
            "uid": self.uid,
            "friends": self.friends
        ]
    }
}
