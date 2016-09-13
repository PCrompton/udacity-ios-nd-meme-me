//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Paul Crompton on 9/10/16.
//  Copyright © 2016 Paul Crompton. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController {

    var memeTextAttributes = TextAttributes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Meme.memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as! MemeTableViewCell
        let meme = Meme.memes[indexPath.row]
        cell.memeImageView.image = meme.originalImage
        cell.memeImageView.clipsToBounds = true
        memeTextAttributes.fontSize = 20
        cell.topTextLabel.attributedText =  NSAttributedString(string: meme.topText, attributes: memeTextAttributes.textAttributes)
        cell.bottomTextLabel.attributedText = NSAttributedString(string: meme.bottomText, attributes: memeTextAttributes.textAttributes)
        cell.tableLabel.text = "\(meme.topText)...\(meme.bottomText)"
        cell.setEditing(true, animated: true)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        createAndPresentDetailVC(indexPath.row)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete") { (action, indexPath) in
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            Meme.memes.removeAtIndex(indexPath.row)
            tableView.endUpdates()
        }
        return [deleteAction]
    }
    
    func reloadData() {
        if tableView != nil {
            tableView.reloadData()
        }
    }
}