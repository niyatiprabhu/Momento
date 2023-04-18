//
//  FriendsViewController.swift
//  Momento
//
//  Created by jasmine wang on 3/5/23.
//

import UIKit
import FirebaseCore
import Firebase
import FirebaseFirestore

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var myFriends:[User] = []
    var friendIds:[String] = []
    let db = Firestore.firestore()


    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(FriendsTableViewCell.nib(), forCellReuseIdentifier: FriendsTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        let group = DispatchGroup()
        
        // get the current user's data for friends' uids
        group.enter()
        if let user = Auth.auth().currentUser {
            // User is signed in.
            print("current user id is \(user.uid)")
            let userRef = Firestore.firestore().collection("users").document(user.uid)
            userRef.getDocument { (snapshot, error) in
                if let error = error {
                    print("Error getting user document: \(error.localizedDescription)")
                    return
                }
                guard let friends = snapshot?.data()?["friends"] as? [String] else {
                    print("User document has no friends array")
                    return
                }
                print("size of friendsIds is \(friends.count)")
                self.friendIds = friends
                group.leave()
            }
        }
        
        // construct User objects from the friends' uids and add to the array
        
        for friendId in friendIds {
            let friendRef = Firestore.firestore().collection("users").document(friendId)
            group.enter()
            friendRef.getDocument { (snapshot, error) in
                if let error = error {
                    print("Error getting user document: \(error.localizedDescription)")
                    print("in here 1")
                    return
                }
                guard let data = snapshot?.data() else {
                    print("User document has no friends array")
                    print ("in here")
                    return
                }
                print ("about to add friend to myFriends")
                let friendUser = User(dictionary: data)
                self.myFriends.append(friendUser!)
                group.leave()
            }
            
        }
        print("number of friends in myFriends is \(myFriends.count)")
       
        
        group.notify(queue: DispatchQueue.main, execute: {
            print("pulled friends")
            self.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myFriends.removeAll()
        friendIds.removeAll()
        
        let group = DispatchGroup()
        
        // get the current user's data for friends' uids
        group.enter()
        if let user = Auth.auth().currentUser {
            // User is signed in.
            let userRef = Firestore.firestore().collection("users").document(user.uid)
            userRef.getDocument { (snapshot, error) in
                if let error = error {
                    print("Error getting user document: \(error.localizedDescription)")
                    return
                }
                guard let friends = snapshot?.data()?["friends"] as? [String] else {
                    print("User document has no friends array")
                    return
                }
                self.friendIds = friends
                group.leave()
            }
        }
        
        // construct User objects from the friends' uids and add to the array
        group.enter()
        for friendId in friendIds {
            let friendRef = Firestore.firestore().collection("users").document(friendId)
            friendRef.getDocument { (snapshot, error) in
                if let error = error {
                    print("Error getting user document: \(error.localizedDescription)")
                    return
                }
                guard let data = snapshot?.data() else {
                    print("User document has no friends array")
                    return
                }
                let friendUser = User(dictionary: data)
                self.myFriends.append(friendUser!)
            }
        }
        group.leave()
        
        group.notify(queue: DispatchQueue.main, execute: {
            print("pulled friends")
            self.tableView.reloadData()
            for friend in self.myFriends {
                print(friend.uid)
            }
        })
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
