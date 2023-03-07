//
//  ProfileViewController.swift
//  Momento
//
//  Created by jasmine wang on 3/5/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let postSegueIdentifier = "PostSegueIdentifier"
    var dateToSend:DateComponents?
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCalendar()
    }
    
    func createCalendar() {
        let calendarView = UICalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.calendar = .current
        calendarView.locale = .current
        calendarView.fontDesign = .rounded
        calendarView.delegate = self
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            calendarView.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 15),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == postSegueIdentifier, let nextVC = segue.destination as? PostViewController {
            nextVC.dateComponents = dateToSend!
        }
    }

}

extension ProfileViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        if dateComponents != nil {
            print(dateComponents!)
            dateToSend = dateComponents
            performSegue(withIdentifier: postSegueIdentifier, sender: nil)
        }
    }
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        guard let day = dateComponents.day else {
            return nil
        }
        
        // decorate based on some condition
        if !day.isMultiple(of: 4) {
            return UICalendarView.Decoration.default(size: .large)
        }
        return nil
    }
}
