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
    var photoURL: String
    let response: String
    let prompt: String
    let color: UIColor!
    let mood: String
    
    init(photoURL: String, textResponse: String, todayDate: DateComponents, userID: String, backgroundColor: UIColor, todayMood: String ) {
        date = todayDate
        self.photoURL = photoURL
        response = textResponse
        authorID = userID
        prompt = "What made you happy today?"
        color = backgroundColor
        mood = todayMood
    }
    
    init(dict: [String: Any]) {
        date = JournalEntry.getDateComponentFromString(dateString: dict["dateString"] as! String)
        self.photoURL = dict["photoURL"] as! String
        response = dict["response"] as! String
        authorID = dict["authorID"] as! String
        prompt = dict["prompt"] as! String
        color = UIColor.colorWithHexString(hexString: dict["color"] as! String) 
        mood = dict["mood"] as! String
    }
    
    var dictionary: [String: Any] {
        return [
            "photoURL": photoURL,
            "dateString": JournalEntry.getDateString(date: date),
            "authorID": authorID,
            "response": response,
            "prompt": prompt,
            "color": color.hexString,
            "mood": mood
        ]
    }
    
    static func getDateComponentFromString(dateString: String) -> DateComponents {
        var dateComp = DateComponents()
        let stringPieces = dateString.split(separator: " ")
        
        let monthInt:Int
        switch stringPieces[0] {
        case "January":
            monthInt = 1
        case "February":
            monthInt = 2
        case "March":
            monthInt = 3
        case "April":
            monthInt = 4
        case "May":
            monthInt = 5
        case "June":
            monthInt = 6
        case "July":
            monthInt = 7
        case "August":
            monthInt = 8
        case "September":
            monthInt = 9
        case "October":
            monthInt = 10
        case "November":
            monthInt = 11
        case "December":
            monthInt = 12
        default:
            monthInt = -1
        }
        
        dateComp.month = monthInt
        dateComp.day = Int(stringPieces[1].split(separator: ",")[0])
        dateComp.year = Int(stringPieces[2].split(separator: " ")[0])
        return dateComp
    }

    static func getDateString(date: DateComponents) -> String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        guard let d = calendar.date(from: date) else {
            print("error occurred")
            return ""
        }
        return dateFormatter.string(from: d)
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
    
    static func colorWithHexString(hexString: String, alpha:CGFloat = 1.0) -> UIColor {

        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0

        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }

    static func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        // Scan hex value
        hexInt = UInt32(bitPattern: scanner.scanInt32(representation: .hexadecimal) ?? 0)
        return hexInt
    }

}
