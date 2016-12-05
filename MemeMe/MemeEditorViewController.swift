//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Paul Crompton on 7/18/16.
//  Copyright © 2016 Paul Crompton. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    let topTextDefault = "TOP"
    let bottomTextDefault = "BOTTOM"
    let memeTextAttributes = TextAttributes()
    var meme: Meme?
    
// MARK: override functions
    
    func configureTextField(_ textField: UITextField, text: String) {
        textField.delegate = self
        textField.text = text
        textField.defaultTextAttributes = memeTextAttributes.textAttributes
        textField.textAlignment = NSTextAlignment.center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let topText: String
        let bottomText: String
        if let meme = meme {
            imageView.image = meme.originalImage
            topText = meme.topText
            bottomText = meme.bottomText
        } else {
            topText = topTextDefault
            bottomText = bottomTextDefault
        }
        configureTextField(topTextField, text: topText)
        configureTextField(bottomTextField, text: bottomText)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            cameraButton.isEnabled = false
        }
        if (imageView.image == nil) {
            shareButton.isEnabled = false
            saveButton.isEnabled = false
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
// MARK: Meme functions
    
    func generateMemedImage() -> UIImage {
        
        let previousColor = view.backgroundColor
        view.backgroundColor = UIColor.black
        hideToolbars(true)
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        view.backgroundColor = previousColor
        hideToolbars(false)
        
        return memedImage
    }
    
    func hideToolbars(_ hidden: Bool) {
        topToolbar.isHidden = hidden
        bottomToolbar.isHidden = hidden
    }
    
    @IBAction func saveButton(_ sender: AnyObject) {
        save()
        dismiss()
    }
    func save() {
        let meme = Meme.init(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
        Meme.memes.append(meme)
        let tableViewController = self.presentingViewController?.childViewControllers[0].childViewControllers[0] as! MemeTableViewController
        let collectionViewController = self.presentingViewController?.childViewControllers[0].childViewControllers[1] as! MemeCollectionViewController
        tableViewController.reloadData()
        collectionViewController.reloadData()

    }
    
    @IBAction func shareButton(_ sender: AnyObject) {
        shareMeme(memedImage: generateMemedImage()) { (activityType, completed, returnedItems, activityError) in
            if completed {
                self.save()
            }}
    }
    
    @IBAction func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }

// MARK image controllers
    
    @IBAction func pickAnImage(_ sender: AnyObject) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let camera = UIImagePickerControllerSourceType.camera
        let photoLibrary = UIImagePickerControllerSourceType.photoLibrary
        
        if sender.tag == 1 {
            imagePickerController.sourceType = camera
        } else {
            imagePickerController.sourceType = photoLibrary
        }
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        if let image = image {
            imageView.image = image
            shareButton.isEnabled = true
            saveButton.isEnabled = true
        } else {
            imageView.image = nil
        }
        
        imagePickerControllerDidCancel(picker)
 
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    

// MARK textFieldDelegate functions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField === self.bottomTextField {
            subscribeToKeyboardNotifications()
        }
        
        if textFieldShouldClear(textField) {
            textField.text = ""
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("\(type(of: self)).textFieldShouldClear()")
        
        return textField.text == topTextDefault || textField.text == bottomTextDefault ? true: false
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("\(type(of: self)).textFieldShouldReturn()")
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        unsubscribeToKeyboardNotifications()
    }
    
// MARK keyboard show/hide
    
    func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
        topToolbar.isHidden = true
        topTextField.isHidden = true
        
    }
    
    func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y += getKeyboardHeight(notification)
        topToolbar.isHidden = false
        topTextField.isHidden = false
        
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}

extension UIImagePickerController {
    override open var prefersStatusBarHidden : Bool {
        return true
    }
}
