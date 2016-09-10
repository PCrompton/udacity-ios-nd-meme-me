//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Paul Crompton on 7/18/16.
//  Copyright © 2016 Paul Crompton. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

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
        let TopText: String
        let BottomText: String
        let originalImage: UIImage
        let memedImage: UIImage
    }
    
// MARK: override functions
    
    func configureTextField(textField: UITextField, defaultText: String) {
        textField.delegate = self
        textField.text = defaultText
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.Center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField(topTextField, defaultText: topTextDefault)
        configureTextField(bottomTextField, defaultText: bottomTextDefault)
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
        
        let previousColor = view.backgroundColor
        view.backgroundColor = UIColor.blackColor()
        hideToolbars(true)
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        view.backgroundColor = previousColor
        hideToolbars(false)
        
        return memedImage
    }
    
    func hideToolbars(hidden: Bool) {
        topToolbar.hidden = hidden
        bottomToolbar.hidden = hidden
    }
    
    func save() -> Meme {
        let meme = Meme.init(TopText: topTextField.text!, BottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
        return meme
    }

    @IBAction func shareMeme(sender: AnyObject) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {(activityType, completed, returnedItems, activityError) in
            if completed {
                self.save()
            }
        }
        
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
}