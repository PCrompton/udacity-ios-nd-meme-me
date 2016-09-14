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
        let memeDetailVC = storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailVC.meme = Meme.memes[index]
        show(memeDetailVC, sender: self)
    }
    
    func shareMeme(memedImage: UIImage, completion: ((UIActivityType?, Bool, [Any]?, Error?) -> Void)?) {
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = completion
        present(activityViewController, animated: true, completion: nil)
    }
}
