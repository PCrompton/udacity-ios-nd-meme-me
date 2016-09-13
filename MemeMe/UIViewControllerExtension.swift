//
//  UIViewControllerExtension.swift
//  MemeMe
//
//  Created by Paul Crompton on 9/11/16.
//  Copyright © 2016 Paul Crompton. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func createAndPresentDetailVC(index: Int) {
        let memeDetailVC = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        memeDetailVC.meme = Meme.memes[index]
        showViewController(memeDetailVC, sender: self)
    }
    
    func shareMeme(memedImage: UIImage, completion: ((String?, Bool, [AnyObject]?, NSError?) -> Void)?) {
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = completion
        presentViewController(activityViewController, animated: true, completion: nil)
    }
}