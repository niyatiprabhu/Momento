//
//  JournalEntry.swift
//  Momento
//
//  Created by Niyati Prabhu on 3/5/23.
//

import Foundation
import UIKit

class JournalEntry {
    let date: DateComponents
    let author: User
    var photo: UIImage?
    let text: String
    
    init(photoUpload: UIImage, textResponse: String, todayDate: DateComponents, user: User) {
        date = todayDate
        photo = photoUpload
        text = textResponse
        author = user
    }
}
