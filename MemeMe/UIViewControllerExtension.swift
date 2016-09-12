//
//  UIViewControllerExtension.swift
//  MemeMe
//
//  Created by Paul Crompton on 9/11/16.
//  Copyright © 2016 Paul Crompton. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController: DismissalDelegate {
    func createAndPresentDetailVC(index: Int) {
        let memeDetailVC = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        memeDetailVC.meme = Meme.memes[index]
        memeDetailVC.dismissalDelegate = self
        presentViewController(memeDetailVC, animated: true, completion: nil)
    }
    
    func dismissAndPresentNew(VCToDismiss: MemeDetailViewController, VCToPresent: MemeEditorViewController) {
        VCToDismiss.dismissViewControllerAnimated(true, completion: nil)
        presentViewController(VCToPresent, animated: true, completion: nil)
    }
}