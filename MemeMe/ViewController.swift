//
//  ViewController.swift
//  MemeMe
//
//  Created by Paul Crompton on 7/18/16.
//  Copyright © 2016 Paul Crompton. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    let topTextDefault = "TOP"
    let bottomTextDefault = "BOTTOM"

    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -1.0
    ]
    
    struct Meme {
        let text: [String: String]
        let originalImage: UIImage
        let memedImage: UIImage
    }
    
// MARK: override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        topTextField.text = topTextDefault
        bottomTextField.text = bottomTextDefault
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.textAlignment = NSTextAlignment.Center
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            cameraButton.enabled = false
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

// MARK: Meme functions
    
    func generateMemedImage() -> UIImage {
       
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
                                     afterScreenUpdates: true)

        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    func hideToolbars(hidden: Bool) {
        topToolbar.hidden = hidden
        bottomToolbar.hidden = hidden
    }
    
    func saveMeme() -> Meme {
        
        let previousColor = view.backgroundColor
        view.backgroundColor = UIColor.blackColor()
        hideToolbars(true)
        
        let meme = Meme.init(text: ["top": topTextField.text!, "bottom": bottomTextField.text!], originalImage: imageView.image!, memedImage: generateMemedImage())
        
        view.backgroundColor = previousColor
        hideToolbars(false)

        return meme
    }

    @IBAction func shareMeme(sender: AnyObject) {
        
        let activityViewController = UIActivityViewController(activityItems: [self.saveMeme().memedImage], applicationActivities: nil)
        
        presentViewController(activityViewController, animated: true, completion: nil)
    
    }
// MARK image controllers
    
    @IBAction func pickAnImage(sender: AnyObject) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let camera = UIImagePickerControllerSourceType.Camera
        let photoLibrary = UIImagePickerControllerSourceType.PhotoLibrary
        
        if sender.tag == 1 {
            imagePickerController.sourceType = camera
        } else {
            imagePickerController.sourceType = photoLibrary
        }
        
        presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        if let image = image {
            self.imageView.image = image
        } else {
            self.imageView.image = nil
        }
        
        imagePickerControllerDidCancel(picker)
 
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

// MARK textFieldDelegate functions
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField === self.bottomTextField {
            subscribeToKeyboardNotifications()
        }
        
        
        if textFieldShouldClear(textField) {
            textField.text = ""
        }
        
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        print("\(self.dynamicType).textFieldShouldClear()")
        
        return textField.text == topTextDefault || textField.text == bottomTextDefault ? true: false
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("\(self.dynamicType).textFieldShouldReturn()")
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        unsubscribeToKeyboardNotifications()
    }
    
// MARK keyboard show/hide
    
    func keyboardWillShow(notification: NSNotification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
        topToolbar.hidden = true
        topTextField.hidden = true
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y += getKeyboardHeight(notification)
        topToolbar.hidden = false
        topTextField.hidden = false
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
}