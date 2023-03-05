//
//  PostViewController.swift
//  Momento
//
//  Created by jasmine wang on 3/5/23.
//

import UIKit

class PostViewController: UIViewController {

    var dateComponents:DateComponents?
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if dateComponents != nil {
            print(dateComponents!)
            let calendar = Calendar.current
            var date = calendar.date(from: dateComponents!)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy"
            if let d = date {
                let dateString = dateFormatter.string(from: d)
                dateLabel.text = dateString
            }
        }
    }

}
