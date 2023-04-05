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
    let authorID: String
    var photo: String
    let response: String
    let prompt: String
    let color: UIColor!
    let mood: String
    
    init(photoURL: String, textResponse: String, todayDate: DateComponents, userID: String, backgroundColor: UIColor, todayMood: String ) {
        date = todayDate
        photo = photoURL
        response = textResponse
        authorID = userID
        prompt = "What made you happy today?"
        color = backgroundColor
        mood = todayMood
    }
    
    var dictionary: [String: Any] {
        return [
            "date": date,
            "authorID": authorID,
            "response": response,
            "prompt": prompt,
            "color": color.hexString,
            "mood": mood
        ]
    }
    
}

extension UIColor {
    var hexString: String {
        let components = self.cgColor.components
        let red = components?[0] ?? 0.0
        let green = components?[1] ?? 0.0
        let blue = components?[2] ?? 0.0

        let hexString = String(format: "%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255))
        return hexString
    }
}
