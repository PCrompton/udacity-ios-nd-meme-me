//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Paul Crompton on 9/10/16.
//  Copyright © 2016 Paul Crompton. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    var meme: Meme?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        if let meme = meme {
            imageView.image = meme.memedImage
        }
    }
    
    @IBAction func editButton(sender: AnyObject) {
        let memeEditorVC = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        memeEditorVC.meme = meme
        presentViewController(memeEditorVC, animated: true) {self.navigationController?.popToRootViewControllerAnimated(true)}
    }
    @IBAction func shareButton(sender: AnyObject) {
        shareMeme(meme!.memedImage) { (activityType, completed, returnedItems, activityError) in
            if completed {
                self.navigationController?.popToRootViewControllerAnimated(true)
            }}
    }
}
