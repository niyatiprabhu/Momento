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

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedContoller: UISegmentedControl!
    
    var displayData:[User] = []
    var myFriends:[User] = []
    var friendIds:[String] = []
    var addFriends:[User] = []
    let db = Firestore.firestore()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(FriendsTableViewCell.nib(), forCellReuseIdentifier: FriendsTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        
        let group = DispatchGroup()
        
        group.enter()
        // get the current user's data for friends' uids
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
                
                // construct User objects from the friends' uids and add to the array
                for friendId in self.friendIds {
                    group.enter()
                    let friendRef = self.db.collection("users").document(friendId)
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
                        group.leave()
                    }
                }
                
                // get list of users who are not currently friends and are not me
                group.enter()
                self.db.collection("users").getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        for document in querySnapshot!.documents {
                            let id = document.documentID
                            if id != user.uid && !self.friendIds.contains(id) {
                                if let user = User(dictionary: document.data()) {
                                    self.addFriends.append(user)
                                }
                            }
                        }
                        group.leave()
                    }
                }
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main, execute: {
            print("number of friends in myFriends is \(self.myFriends.count)")
            print("number of potential friends to add is \(self.addFriends.count)")
            self.displayData = self.myFriends
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Navigation
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentedContoller.selectedSegmentIndex == 1 {
            
            let group = DispatchGroup()
            group.enter()
            let friend = addFriends[indexPath.row]
            myFriends.append(friend)
            friendIds.append(friend.uid)
            
            let currentUserId = Auth.auth().currentUser?.uid
            let userRef = Firestore.firestore().collection("users").document(currentUserId!)
            userRef.updateData([
                "friends": FieldValue.arrayUnion([friend.uid])
            ]) { error in
                if let error = error {
                    print("Error adding friend: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        self.addFriends.remove(at: indexPath.row)
                        tableView.reloadData()
                    }
                    group.leave()
                    // alert the user that the friend was successfully added
                    let controller = UIAlertController(
                        title: "Yay!",
                        message: "\(friend.username) was successfully added as a friend! 😁",
                        preferredStyle: .alert)
                    
                    controller.addAction(UIAlertAction(
                        title: "OK",
                        style: .default))
                    
                    self.present(controller, animated: true)
                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendsTableViewCell.identifier, for: indexPath) as! FriendsTableViewCell
        let row = indexPath.row
        cell.configure(with: displayData[row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if segmentedContoller.selectedSegmentIndex == 0 && editingStyle == .delete {
            // remove from data and update the table
            let friendIdToDelete = myFriends[indexPath.row].uid
            let userId = Auth.auth().currentUser?.uid
            let userRef = Firestore.firestore().collection("users").document(userId!)
            userRef.updateData([
                "friends": FieldValue.arrayRemove([friendIdToDelete])
            ])
            let friendToDelete = myFriends[indexPath.row]
            myFriends.remove(at: indexPath.row)
            addFriends.append(friendToDelete)
            displayData = myFriends
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if segmentedContoller.selectedSegmentIndex == 0 {
            // search within my friends

        } else {
            // search within global users
            displayData = searchFromAllUsers(username: searchText)
        }
        tableView.reloadData()
    }
    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        if segmentedContoller.selectedSegmentIndex == 0 {
//            // search within my friends
//
//        } else {
//            // search within global users
//            displayData = searchFromAllUsers(username: searchBar.text!)
//        }
//        tableView.reloadData()
//    }
    
    @IBAction func segmentedControllerChanged(_ sender: Any) {
        if segmentedContoller.selectedSegmentIndex == 1 {
            searchBar.placeholder = "search to add friends"
            displayData = addFriends
        } else {
            searchBar.placeholder = "search my friends"
            displayData = myFriends
        }
        tableView.reloadData()
    }
    
    func searchFromAllUsers(username: String) -> [User] {
        var matchingUsers: [User] = []
        // Create a query that filters the 'users' collection by the 'username' field
        let query = db.collection("users").whereField("username", isEqualTo: username)
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let user = User(dictionary: document.data())
                    matchingUsers.append(user!)
                }
            }
        }
        return matchingUsers
    }
    
}
