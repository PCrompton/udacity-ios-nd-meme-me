//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Paul Crompton on 9/10/16.
//  Copyright © 2016 Paul Crompton. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: MemeViewController {
    override func viewDidLoad() {
        if let meme = meme {
            imageView.image = meme.memedImage
        }
    }
    
    @IBAction func shareButton(sender: AnyObject) {
        shareMeme(imageView.image!, completion: nil)
    }

    @IBAction func editButton(sender: AnyObject) {
        let memeEditorViewController = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        memeEditorViewController.meme = meme
        dismissalDelegate?.dismissAndPresentNew(self, VCToPresent: memeEditorViewController)
    }
}
