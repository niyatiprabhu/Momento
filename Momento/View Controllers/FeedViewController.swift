//
//  FeedViewController.swift
//  Momento
//
//  Created by jasmine wang on 3/5/23.
//

import UIKit

class FeedViewController: UIViewController {

    var posts = [JournalEntry]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var dateLabel: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(PostTableViewCell.nib(), forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: Date.now)
        var date = calendar.date(from: dateComponents)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        if let d = date {
            let dateString = dateFormatter.string(from: d)
            dateLabel.title = dateString
        }
        
        let niyatiUser = User(myName: "Niyati Prabhu", myUsername: "@pnini", myEmail: "fake@gmail.com", myPass: "fakePass", myPhoto: UIImage(named: "pfp1")!)
        let jasmineUser = User(myName: "Jasmine Wang", myUsername: "@jasmineyw", myEmail: "fake@gmail.com", myPass: "fakePass", myPhoto: UIImage(named: "pfp2")!)
        let hannahUser = User(myName: "Hannah Clark", myUsername: "@hannahclark", myEmail: "fake@gmail.com", myPass: "fakePass", myPhoto: UIImage(named: "pfp3")!)
        let shadinUser = User(myName: "Shadin Hussein", myUsername: "@shadowz", myEmail: "fake@gmail.com", myPass: "fakePass", myPhoto: UIImage(named: "pfp4")!)
        
        posts.append(JournalEntry(photoUpload: UIImage(named: "post1")!, textResponse: "Went on a hike with my friends!", todayDate: dateComponents, user: niyatiUser, backgroundColor: UIColor(red: 200, green: 30, blue: 0, alpha: 0.5)))
        posts.append(JournalEntry(photoUpload: UIImage(named: "post2")!, textResponse: "Got boba from coco's!", todayDate: dateComponents, user: jasmineUser, backgroundColor: UIColor(red: 0, green: 157, blue: 88, alpha: 0.2)))
        posts.append(JournalEntry(photoUpload: UIImage(named: "post3")!, textResponse: "Worked on a painting!", todayDate: dateComponents, user: hannahUser, backgroundColor: UIColor(red: 100, green: 0, blue: 88, alpha: 0.2)))
        posts.append(JournalEntry(photoUpload: UIImage(named: "post4")!, textResponse: "Did a yoga class with friends!", todayDate: dateComponents, user: shadinUser, backgroundColor: UIColor(red: 160/255.0, green: 217/255.0, blue: 88/255.0, alpha: 1.0)))

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

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
