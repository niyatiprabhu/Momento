//
//  CreateEntryViewController.swift
//  Momento
//

import UIKit
import HealthKit

class CreateEntryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, StickerPickerDelegate {
    
    var selectedColor = UIColor.white
    var postImage:UIImage = UIImage(named: "placeholder")!
    var placeholderText:String = "share your thoughts..."
//    var activeSticker: Sticker?
//    var allStickers: [Sticker] = []
    var moodStickers:String = ""
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var colorWell: UIColorWell!
    @IBOutlet weak var textResponseView: UITextView!
    @IBOutlet weak var moodLabel: UILabel!
    
    
    // Retrieve health data from user's phone
    override func viewWillAppear(_ animated: Bool) {
        
    }
    // set up textField attribues and color well
    override func viewDidLoad() {
        super.viewDidLoad()
        textResponseView.delegate = self
        textResponseView.text = placeholderText
        textResponseView.textColor = UIColor.lightGray
        setupColorWell()
        moodLabel.text = ""
    }
    
    // MARK: - navigation
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: false)
    }
     
    @IBAction func onPostPressed(_ sender: Any) {
        // Fields are missing, present alert to user
        if imageView.image!.isEqualToImage(UIImage(named: "placeholder")!) || textResponseView.textColor == UIColor.lightGray {
            // Create new Alert
             var dialogMessage = UIAlertController(title: "Missing Fields", message: "Fields are required.", preferredStyle: .alert)
             
             // Create OK button with action handler
             let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
             
             //Add OK button to a dialog message
             dialogMessage.addAction(ok)
             // Present Alert to
             self.present(dialogMessage, animated: true, completion: nil)
        }
        
        let calendar = Calendar.current
        let today = calendar.dateComponents([.year, .month, .day], from: Date.now)
        let newPost = JournalEntry(photoUpload: postImage, textResponse: textResponseView.text!, todayDate: today, user: GlobalVariables.currentUser, backgroundColor: selectedColor)
        
        // eventually push entry to firebase storage instead
        GlobalVariables.myPosts.append(newPost)
        GlobalVariables.allPosts.append(newPost)
        self.dismiss(animated: false)
    }
    
    // MARK: - image picking
    // pop up to allow a user to select an image from camera roll
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected an image but didn't find one")
        }
        postImage = image
        imageView.image = postImage
        dismiss(animated:true)
    }
    
    @IBAction func uploadPhotoPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
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
    
//  MARK: - Mood Picker Code
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
    
//    MARK: - 

}


extension UIImage {

    func isEqualToImage(_ image: UIImage) -> Bool {
        return self.pngData() == image.pngData()
    }

}



