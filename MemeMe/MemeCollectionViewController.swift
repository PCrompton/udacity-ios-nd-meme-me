//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Paul Crompton on 9/10/16.
//  Copyright © 2016 Paul Crompton. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memeTextAttributes = TextAttributes()
    
    let itemsPerRowInPortrait = 2
    let itemsPerRowInLandscape = 4
    let spaceBetweenItems: CGFloat = 3.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
         configureFlowLayout(viewWidth: self.view.frame.width, viewHeight: self.view.frame.height)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let newWidth = self.view.frame.height
        let newHeight = self.view.frame.width
        configureFlowLayout(viewWidth: newWidth, viewHeight: newHeight)
        
    }
    
    func configureFlowLayout(viewWidth width: CGFloat, viewHeight height: CGFloat) {
        let numPerRow: Int
        if width < height {
            numPerRow = itemsPerRowInPortrait
        } else {
            numPerRow = itemsPerRowInLandscape
        }
        let dimension = (width - (CGFloat(numPerRow-1) * spaceBetweenItems)) / CGFloat(numPerRow)
        flowLayout.minimumInteritemSpacing = spaceBetweenItems
        flowLayout.minimumLineSpacing = spaceBetweenItems
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)

    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Meme.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MemeCollectionViewCell
        let meme = Meme.memes[(indexPath as NSIndexPath).row]
        cell.memeImageView.image = meme.originalImage
        memeTextAttributes.fontSize = 25
        cell.topTextLabel.attributedText = NSAttributedString(string: meme.topText, attributes: memeTextAttributes.textAttributes)
        cell.bottomTextLabel.attributedText = NSAttributedString(string: meme.bottomText, attributes: memeTextAttributes.textAttributes)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        createAndPresentDetailVC(index: (indexPath as NSIndexPath).item)
    }
    
    func reloadData() {
        if collectionView != nil {
            collectionView!.reloadData()
        }
    }
}
