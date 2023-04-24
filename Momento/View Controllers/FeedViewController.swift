//
//  FeedViewController.swift
//  Momento
//
//  Created by jasmine wang on 3/5/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

var users = [String: User]()

class FeedViewController: UIViewController {

    var posts = [JournalEntry]()
    let db = Firestore.firestore()
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(PostTableViewCell.nib(), forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        // Initialize refresh control
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let group = DispatchGroup()
        
        posts.removeAll()
        users.removeAll()
        
        group.enter()
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let id = document.documentID
                    let data = document.data()
                    let user = User(dictionary: data)
                    users[id] = user
                }
                group.leave()
            }
        }
        
        group.enter()
        db.collection("posts").order(by: "timestamp", descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.posts.append(JournalEntry(dict: document.data()))
                }
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main, execute: {
            print("pulled users and posts data")
            self.tableView.reloadData()
        })
    }
    
    // Add pull-to-refresh function
    @objc private func pullToRefresh() {
        // Call your viewWillAppear method again to reload data
        viewWillAppear(true)
        // End refreshing
        self.refreshControl.endRefreshing()
    }
}


extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        
        // Check that the index is within the bounds of the `posts` array
          guard indexPath.row < posts.count else {
              return cell
          }
        
        cell.configure(with: posts[indexPath.row])
        return cell
    }
    
}
