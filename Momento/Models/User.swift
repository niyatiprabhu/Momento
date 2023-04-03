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
    var password: String
    var profilePhoto: UIImage!
    var stepCount: String
    
    
    init(myName: String, myUsername: String, myEmail: String, myPass: String, myPhoto: UIImage, mySteps: String ) {
        name = myName
        username = myUsername
        password = myPass
        email = myEmail
        profilePhoto = myPhoto
        stepCount = mySteps
        
    }
}
