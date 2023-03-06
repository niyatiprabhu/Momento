//
//  CreateEntryViewController.swift
//  Momento
//

import UIKit

class CreateEntryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectedColor = UIColor.white
    
    @IBOutlet weak var textResponseField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var colorWell: UIColorWell!
    
    @IBAction func uploadPhotoPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: false)
    }
     
    // *** ACCCESS SELECTED BACKGROUND COLOR WITH "selectedColor" ***
    @IBAction func onPostPressed(_ sender: Any) {
        let calendar = Calendar.current
        let today = calendar.dateComponents([.year, .month, .day], from: Date.now)
        let newPost = JournalEntry(photoUpload: UIImage(), textResponse: textResponseField.text!, todayDate: today, user: GlobalVariables.currentUser, backgroundColor: selectedColor)
        GlobalVariables.myPosts.append(newPost)
        GlobalVariables.allPosts.append(newPost)
        self.dismiss(animated: false)
    }
    
    // set up textField attribues and color well
    override func viewDidLoad() {
        super.viewDidLoad()
        textResponseField.borderStyle = .roundedRect
        textResponseField.textAlignment = .left
        textResponseField.contentVerticalAlignment = .top
        setupColorWell()
    }
    
    // image picker pop up- allow a user to select an image from camera roll
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected an image but didn't find one")
        }
        imageView.image = image
        dismiss(animated:true)
    }
    
    // sets up the color well/ makes connection when value changes
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
    
    
}
