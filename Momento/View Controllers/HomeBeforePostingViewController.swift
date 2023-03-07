//
//  HomeBeforePostingViewController.swift
//  Momento
//
//  Created by jasmine wang on 3/6/23.
//

import UIKit

class HomeBeforePostingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func createEntryButtonPressed(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let destination = storyBoard.instantiateViewController(withIdentifier: "CreateEntryViewController") as! CreateEntryViewController
        destination.modalPresentationStyle = .fullScreen
        self.present(destination, animated: false)
    }

}
