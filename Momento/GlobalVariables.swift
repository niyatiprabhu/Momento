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
    static let firstPost = JournalEntry(photoUpload: UIImage(), textResponse: "hello", todayDate: oldDate, user: currentUser)
    static var myPosts: [JournalEntry] = [firstPost]
    static var allPosts: [JournalEntry] = [firstPost]
    
    static let currentUser = User(myName: "Jane Doe", myUsername: "janedo3", myEmail: "jd@gmail.com", myPass: "janeiscool", myPhoto: UIImage())
    
    
}
