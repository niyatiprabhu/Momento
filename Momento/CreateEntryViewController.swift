//
//  CreateEntryViewController.swift
//  Momento
//
//  Created by jasmine wang on 3/5/23.
//

import UIKit

class CreateEntryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var textResponseField: UITextField!
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        textResponseField.borderStyle = .roundedRect
        textResponseField.textAlignment = .left
        textResponseField.contentVerticalAlignment = .top
    }
    
    @IBAction func uploadPhotoPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
            imageView.image = image
            dismiss(animated:true, completion: nil)
        }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func onPostPressed(_ sender: Any) {
        let calendar = Calendar.current
        let today = calendar.dateComponents([.year, .month, .day], from: Date.now)
        var newPost = JournalEntry(photoUpload: UIImage(), textResponse: textResponseField.text!, todayDate: today, user: GlobalVariables.currentUser)
        GlobalVariables.myPosts.append(newPost)
        GlobalVariables.allPosts.append(newPost)
        // display the new post
        performSegue(withIdentifier: "EntryJustPosted", sender: self)
    }
}
