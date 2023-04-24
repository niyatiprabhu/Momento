//
//  PromptPickerViewController.swift
//  Momento
//
//  Created by jasmine wang on 4/18/23.
//

import UIKit

class PromptPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let prompts = ["What made you happy today?", "What did you do today?", "What did you learn today?", "What challenged you today?", "What are you grateful for today?", "What made you laugh today?", "How'd you take care of yourself today?", "What puzzled you today?"]
    
    var selectedPrompt:String = "What made you happy today?"
    var onDismiss: ((String) -> Void)?
    
    @IBOutlet weak var picker: UIPickerView!
    @IBAction func doneBtnPressed(_ sender: Any) {
        onDismiss?(selectedPrompt)
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        prompts.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return prompts[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPrompt = prompts[row]
    }

}
