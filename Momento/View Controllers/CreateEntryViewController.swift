//
//  CreateEntryViewController.swift
//  Momento
//

import UIKit
import HealthKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class CreateEntryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate, StickerPickerDelegate {
    
    var selectedColor = UIColor.white
    var postImage:UIImage = UIImage(named: "placeholder")!
    var placeholderText:String = "share your thoughts..."
    var moodStickers:String = ""
    let imagePicker = UIImagePickerController()
    
    private let storage = Storage.storage().reference()
    
    let database = Firestore.firestore()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var colorWell: UIColorWell!
    @IBOutlet weak var textResponseView: UITextView!
    @IBOutlet weak var moodLabel: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        // TODO: Retrieve health data from user's phone
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up textField attribues and color well
        textResponseView.delegate = self
        textResponseView.text = placeholderText
        textResponseView.textColor = UIColor.lightGray
        setupColorWell()
        moodLabel.text = ""
        imagePicker.delegate = self
    }
      
    // Called when the user clicks on the view outside of the UITextField
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textResponseView.resignFirstResponder()
//        self.view.endEditing(true)
    }
    
    // writes post to Firestore
    func writeData(post: JournalEntry) {
        // combine timestamp and random string to create a unique filename
        let timestamp = Date().timeIntervalSince1970
        let randomString = UUID().uuidString
        let filename = "\(timestamp)-\(randomString)"
        
        let docRef = database.document("posts/\(filename)")
        docRef.setData(post.dictionary)
        docRef.setData(["timestamp": timestamp], merge: true) {
            error in
            if let error = error {
                print("error adding timestamp: \(error)")
            }
        }
    }

    
    // MARK: - navigation
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: false)
    }
     
    @IBAction func onPostPressed(_ sender: Any) {
        // Fields are missing, present alert to user
        if imageView.image!.isEqualToImage(UIImage(named: "placeholder")!) || textResponseView.text == placeholderText {
            // Create new Alert
            let dialogMessage = UIAlertController(title: "Missing Fields", message: "Fields are required.", preferredStyle: .alert)
             
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
             
            //Add OK button to a dialog message
            dialogMessage.addAction(ok)
            // Present Alert to
            self.present(dialogMessage, animated: true, completion: nil)
            return
        }
        
        // upload image to Firebase storage
        guard let imageData = postImage.jpegData(compressionQuality: 0.25) else {
            print("could not get image data")
            return
        }
        
        // combine timestamp and random string to create a unique filename
        let timestamp = Date().timeIntervalSince1970
        let randomString = UUID().uuidString
        let filename = "\(timestamp)-\(randomString)"

        storage.child("images/\(filename).jpg").putData(imageData, completion: { _, error in
            guard error == nil else {
                print("failed to upload: \(error!)")
                return
            }
            
            self.storage.child("images/\(filename).jpg").downloadURL(completion: {url, error in
                guard let url = url, error == nil else {
                    return
                }
                let urlString = url.absoluteString
                print("download url: \(urlString)")
                
                // save post to Firestore
                self.createPost(photoURL: urlString)
            })
        })
    }
    
    func createPost(photoURL: String) {
        let calendar = Calendar.current
        let today = calendar.dateComponents([.year, .month, .day], from: Date.now)
        
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            print("User ID: \(uid)")
        } else {
            print("No user is signed in.")
        }
        
        guard let user = Auth.auth().currentUser else {
            print("No user is signed in")
            return
        }
        
        let newPost = JournalEntry(photoURL: photoURL, textResponse: textResponseView.text!, todayDate: today, userID: user.uid, backgroundColor: selectedColor, todayMood: moodLabel.text!)
        
        print(textResponseView.text!, moodLabel.text!)
        
        // push entry to Firebase storage
        writeData(post: newPost)
        self.dismiss(animated: false)
    }
    
    // MARK: - image picking
    // pop up to allow a user to select an image from camera roll
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected an image but didn't find one")
        }
        let savedText = textResponseView.text
        postImage = image
        imageView.image = postImage
        dismiss(animated:true)
        textResponseView.text = savedText
    }
    
    @IBAction func uploadPhotoPressed(_ sender: Any) {
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
    
    // MARK: - color picking
    // sets up the color well & makes connection when value changes
    func setupColorWell() {
        self.view.addSubview(colorWell)
        colorWell.title = "Background Color"
        colorWell.addTarget(self, action: #selector(colorWellChanged(_:)), for: .valueChanged)
    }
    
    // if color well value changed, change the background
    @objc func colorWellChanged(_ sender: Any) {
        self.view.backgroundColor = colorWell.selectedColor
        selectedColor = colorWell.selectedColor!
    }
    
    // MARK: - text field placeholder
    // functions for handling placeholder text
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textResponseView.textColor == UIColor.lightGray {
            textResponseView.text = ""
            textResponseView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textResponseView.text == "" {
            textResponseView.text = placeholderText
        }
        textResponseView.textColor = UIColor.lightGray
    }
    
    //  MARK: - Mood Picker
    func didPick(_ sticker: String) {
        moodStickers.append(sticker)
        moodLabel.text = moodStickers
    }

    @IBAction func undoLastMood(_ sender: Any) {
        if (moodStickers.count > 0) {
            moodStickers.removeLast()
            moodLabel.text = moodStickers
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStickersSegue",
           let nextVC = segue.destination as? MoodPickerViewController {
            nextVC.delegate = self
        }
    }
}

extension UIImage {

    func isEqualToImage(_ image: UIImage) -> Bool {
        return self.pngData() == image.pngData()
    }

}



