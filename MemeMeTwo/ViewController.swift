//
//  ViewController.swift
//  MemeMeTwo
//
//  Created by Dhruv Shah on 15/08/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField(topTextField, text: "Top")
        setupTextField(bottomTextField, text: "Bottom")
        albumButton.isEnabled = true
        cameraButton.isEnabled =  UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    //Keyboard Subscription
    func subscribeToKeyboardNotifications() {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    
    //Keyboard Unsubscription
    func unsubscribeToKeyboardNotifications() {
            NotificationCenter.default.removeObserver(self)
        }
    
    //Keyboard will show
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
    }
    
    //Keyboard will hide
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    //Keyboard Height
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
            let userInfo = notification.userInfo
            let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
            return keyboardSize.cgRectValue.height
        }
    
    
    //Pick image from photo library
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
            pickAnImage(.camera)
        }
        
    //Pick image by camera roll button
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
            pickAnImage(.photoLibrary)
        }
    
    func pickAnImage(_ source : UIImagePickerController.SourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = source
            present(imagePickerController, animated: true, completion: nil)
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true, completion: nil)
            imageView.image = info[.originalImage] as? UIImage
            if let _ = imageView.image {
                self.shareButton.isEnabled = true
            } else {
                self.shareButton.isEnabled = false
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
            self.shareButton.isEnabled = false
            imageView.image = nil
        }
    
    //Default Text Settings
    func setupTextField(_ textField: UITextField, text: String) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = text
    }
    
    //Text Editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "Top" {
            textField.text = ""
        }
        else if textField.text == "Bottom" {
            textField.text = ""
            subscribeToKeyboardNotifications()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Text Attributes
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "HelveticaNeue", size: 40)!,
        .strokeWidth:  -2
    ]
    
    //Share Meme
    @IBAction func shareMeme(_ sender: Any) {
        let memeImage: UIImage = generatingMeme()
        let controller = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        controller.completionWithItemsHandler = { (type, ok, items, error) in
            if ok {
                self.saveMeme()
            }
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    //Cancel Meme
    @IBAction func cancelMeme(_ sender: Any) {
        albumButton.isEnabled = false
        imageView.image = nil
        topTextField.text = "Top"
        bottomTextField.text = "Bottom"
        dismiss(animated: true, completion: nil)
    }
    
    //Save meme
    func saveMeme() {
        
        let meme = MemeMeTwo(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, newImage: generatingMeme())
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
        dismiss(animated: true, completion: nil)
       
    }
    
    //Generate Meme
    func generatingMeme() -> UIImage {
        // Rendering view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
}


