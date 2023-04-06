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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var dateLabel: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(PostTableViewCell.nib(), forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: Date.now)
        let date = calendar.date(from: dateComponents)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        if let d = date {
            let dateString = dateFormatter.string(from: d)
            dateLabel.title = dateString
        }
        
        let group = DispatchGroup()
        
        posts.removeAll()
        
        group.enter()
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let id = document.documentID
                    let data = document.data()
                    print("\(id) => \(data)")
                    let user = User(dictionary: data)
                    users[id] = user
                }
                print(users.description)
                group.leave()
            }
        }
        
        group.enter()
        db.collection("posts").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.posts.append(JournalEntry(dict: document.data()))
                }
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main, execute: {
            print("pulled users and posts data")
            print(self.posts.description)
            print(users.description)
            self.tableView.reloadData()
        })

    }
    
    
}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        cell.configure(with: posts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
