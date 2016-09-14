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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Meme.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as! MemeTableViewCell
        let meme = Meme.memes[(indexPath as NSIndexPath).row]
        cell.memeImageView.image = meme.originalImage
        cell.memeImageView.clipsToBounds = true
        memeTextAttributes.fontSize = 20
        cell.topTextLabel.attributedText =  NSAttributedString(string: meme.topText, attributes: memeTextAttributes.textAttributes)
        cell.bottomTextLabel.attributedText = NSAttributedString(string: meme.bottomText, attributes: memeTextAttributes.textAttributes)
        cell.tableLabel.text = "\(meme.topText)...\(meme.bottomText)"
        cell.setEditing(true, animated: true)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        createAndPresentDetailVC(index: (indexPath as NSIndexPath).row)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            Meme.memes.remove(at: (indexPath as NSIndexPath).row)
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
