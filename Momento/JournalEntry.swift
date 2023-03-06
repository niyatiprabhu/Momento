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
    let response: String
    let prompt: String
    let color: UIColor
    
    init(photoUpload: UIImage, textResponse: String, todayDate: DateComponents, user: User, backgroundColor:UIColor) {
        date = todayDate
        photo = photoUpload
        response = textResponse
        author = user
        prompt = "What made you happy today?"
        color = backgroundColor
    }
}
