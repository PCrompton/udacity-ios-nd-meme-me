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
    
    @IBAction func editButton(_ sender: AnyObject) {
        let memeEditorVC = storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        memeEditorVC.meme = meme
        present(memeEditorVC, animated: true) {self.navigationController?.popToRootViewController(animated: true)}
    }
    @IBAction func shareButton(_ sender: AnyObject) {
        shareMeme(memedImage: meme!.memedImage) { (activityType, completed, returnedItems, activityError) in
            if completed {
                self.navigationController?.popToRootViewController(animated: true)
            }}
    }
}
