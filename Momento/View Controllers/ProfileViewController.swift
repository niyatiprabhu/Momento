//
//  ProfileViewController.swift
//  Momento
//
//  Created by jasmine wang on 3/5/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestore

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let postSegueIdentifier = "PostSegueIdentifier"
    var entryToSend:JournalEntry?
    var myPosts = Dictionary<String, JournalEntry>()
    var calendar: UICalendarView?
    var pfp:UIImage = UIImage(named: "pfpPlaceholder")!
    let imagePicker = UIImagePickerController()
    let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    var userID:String = ""
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pfpView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.text = ""
        nameLabel.text = ""
        pfpView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pfpViewTapped))
        pfpView.addGestureRecognizer(tapGesture)
        imagePicker.delegate = self
        createCalendar()
        
        guard let user = Auth.auth().currentUser else {
            print("could not get current user")
            return
        }
        userID = user.uid
        
        //set up user's name and username
        db.collection("users").document(userID).getDocument(completion: { (document, err) in
            if let document = document, document.exists, let data = document.data() {
                guard let user = User(dictionary: data) else {
                    print("error creating user from data")
                    return
                }
                self.nameLabel.text = user.name
                self.usernameLabel.text = "@\(user.username)"
            } else {
                print("could not get user info for uid: \(self.userID)")
            }
        })
        
        //set up pfp
        storage.child("pfps/\(userID).jpg").getData(maxSize: 1 * 1024 * 1024, completion: { (data, err) in
            if err != nil {
                print("could not get pfp or none exists for this user")
                self.pfpView.image = UIImage(named: "profilepic")
                return
            }
            guard let data = data else {
                print("error getting pfp data")
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.pfpView.image = image
            }
        })
        
        getPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // get username info bc this might have changed
        let uid = Auth.auth().currentUser?.uid
        let docRef = db.collection("users").document(uid!)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists, let username = document["username"] as? String {
                self.usernameLabel.text = "@\(username)"
            } else {
                print("error getting username")
                self.usernameLabel.text = "@username"
            }
        }
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
        calendar = calendarView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == postSegueIdentifier, let nextVC = segue.destination as? PostViewController {
            nextVC.entry = entryToSend!
        }
    }
    
    func getPosts() {
        db.collection("posts").whereField("authorID", isEqualTo: userID).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let entry = JournalEntry(dict: document.data())
                    let dateString = JournalEntry.getDateString(date: entry.date)
                    self.myPosts[dateString] = entry
                    guard let calendar = self.calendar else {
                        print("no calendar")
                        return
                    }
                    calendar.reloadDecorations(forDateComponents: [entry.date], animated: false)
                }
            }
        }
    }
    
    // MARK: - image picking
    // pop up to allow a user to select an image from camera roll
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected an image but didn't find one")
        }
        pfp = image
        pfpView.image = pfp
        uploadPfp()
        dismiss(animated:true)
    }
    
    func uploadPfp() {
        // upload image to Firebase storage
        guard let imageData = pfp.jpegData(compressionQuality: 0.25) else {
            print("could not get image data")
            return
        }
        
        storage.child("pfps/\(userID).jpg").putData(imageData, completion: { _, err in
            if let err = err {
                print("failed to upload: \(err)")
                return
            }
            print("successfully uploaded pfp!")
        })
    }
    
    @objc func pfpViewTapped() {
        // present an alert controller with options to choose or take a photo
       let alertController = UIAlertController(title: "Choose an Image", message: nil, preferredStyle: .actionSheet)
       
       alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
           self.useCamera()
       }))
       
       alertController.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
           self.usePhotoLibrary()
       }))
       
       alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
       
       self.present(alertController, animated: true, completion: nil)
    }
    
    // show the camera to take a photo
    func useCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera not available")
        }
    }
    
    // show the photo library to choose a photo
    func usePhotoLibrary() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
}

extension ProfileViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        if dateComponents != nil {
            let dateString = JournalEntry.getDateString(date: dateComponents!)
            if let entry = myPosts[dateString] {
                entryToSend = entry
                performSegue(withIdentifier: postSegueIdentifier, sender: nil)
            } else {
                // create alert that says no post that day
                let alertController = UIAlertController(title: "No Entry", message: "You didn't make a post on this day 😢", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                present(alertController, animated: true)
            }
        }
    }
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        
        // decorate if there's a post with this date
        let dateString = JournalEntry.getDateString(date: dateComponents)
        if myPosts.contains(where: {$0.key == dateString}) {
            return UICalendarView.Decoration.default(color: .systemTeal, size: .large)
        }
        return nil
    }
}
