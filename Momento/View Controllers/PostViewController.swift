//
//  PostViewController.swift
//  Momento
//
//  Created by jasmine wang on 3/5/23.
//

import UIKit
import FirebaseAuth

class PostViewController: UIViewController {

    var entry: JournalEntry!

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postBackground: UIView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var responseLabel: UILabel!
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var shoes: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = JournalEntry.getDateString(date: entry.date)
        postBackground.backgroundColor = entry.color
        let textColor: UIColor = entry.color.isLight ? .black : .white
        let tintColor = textColor.withAlphaComponent(0.6)
        print ("text color \(textColor)")
        promptLabel.textColor = textColor
        responseLabel.textColor = textColor
        stepsLabel.textColor = tintColor
        shoes.tintColor = tintColor
        setImage(from: URL(string: entry.photoURL)!)
        promptLabel.text = entry.prompt
        responseLabel.text = entry.response
        moodLabel.text = entry.mood
        stepsLabel.text = entry.getFormattedSteps()
    }
    
    // set post image
    func setImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.postImageView.image = UIImage(data: data)
                }
            }
        }.resume()
    }

}

////Calculate the brightness of the background/color selected
//extension UIColor {
//    var isLight: Bool {
//        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
//        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
//        let brightness = ((red * 299) + (green * 587) + (blue * 114)) / 1000
//        return brightness >= 0.5
//    }
//}
//
//
//extension UIView {
//    //recursively set the text color of labels, textFields, and views
//    func recursivelySetTextColor(_ color: UIColor) {
//        if let label = self as? UILabel {
//            label.textColor = color
//        }
////        else if let textView = self as? UITextView {
////            textView.textColor = color
////        }
//        else if let textField = self as? UITextField {
//            textField.textColor = color
//        }
//
//        for subview in subviews {
//            subview.recursivelySetTextColor(color)
//        }
//    }
//}
