//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Paul Crompton on 9/11/16.
//  Copyright © 2016 Paul Crompton. All rights reserved.
//

import Foundation
import UIKit

class MemeViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topToolbar: UIToolbar!
    
    var meme: Meme?
    
    var dismissalDelegate: DismissalDelegate?
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func shareMeme(memedImage: UIImage, completion: ((String?, Bool, [AnyObject]?, NSError?) -> Void)?) {
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = completion
        presentViewController(activityViewController, animated: true, completion: nil)
    }
}