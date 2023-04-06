//
//  GlobalVariables.swift
//  Momento
//
//  Created by Niyati Prabhu on 3/5/23.
//

import Foundation
import UIKit

struct GlobalVariables {
    
    static let oldDate = DateComponents(year:2023, month: 3, day: 2)
//    static let firstPost = JournalEntry(photoUpload: UIImage(named: "placeholder")!, textResponse: "hello", todayDate: oldDate, user: currentUser, backgroundColor: UIColor.white, todayMood: ":)")
    
    static var myPosts: [JournalEntry] = []
    static var allPosts: [JournalEntry] = []
    
    static let currentUser = User(myName: "Jane Doe", myUsername: "janedo3", myEmail: "jd@gmail.com", myPass: "janeiscool", myPhoto: UIImage(named: "placeholder")!, mySteps: "0")
    
    static let zuck = User(myName: "Mark Zuck", myUsername: "zuck", myEmail: "zuck@gmail.com", myPass: "zuck", myPhoto: UIImage(named: "pfp1")!, mySteps: "0")
    
    static let obama = User(myName: "Barack", myUsername: "potus", myEmail: "usa@gmail.com", myPass: "potus", myPhoto: UIImage(named: "pfp1")!, mySteps: "1000")
    
    static let katniss = User(myName: "Katniss Everdeen", myUsername: "kat", myEmail: "hungergames@gmail.com", myPass: "kat", myPhoto: UIImage(named: "pfp1")!, mySteps: "50000")
    
    static var allFriends: [User] = [zuck, obama, katniss]
    
    static var globalStepCount = "0"
    
    
}
