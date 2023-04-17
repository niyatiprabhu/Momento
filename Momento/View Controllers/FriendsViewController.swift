//
//  FriendsViewController.swift
//  Momento
//
//  Created by jasmine wang on 3/5/23.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var myFriends:[User] = GlobalVariables.allFriends

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(FriendsTableViewCell.nib(), forCellReuseIdentifier: FriendsTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    // MARK: - Navigation
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendsTableViewCell.identifier, for: indexPath) as! FriendsTableViewCell
        let row = indexPath.row
        cell.configure(with: myFriends[row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // remove from data and update the table
            myFriends.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
