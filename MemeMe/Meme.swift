//
//  Meme.swift
//  MemeMe
//
//  Created by Paul Crompton on 9/10/16.
//  Copyright © 2016 Paul Crompton. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    let topText: String
    let bottomText: String
    let originalImage: UIImage
    let memedImage: UIImage

    static var memes = [Meme]()
    
}

struct TextAttributes {
    var strokeColor = UIColor.blackColor()
    var foregroundColor = UIColor.whiteColor()
    var fontSize: CGFloat = 40
    var fontName = "HelveticaNeue-CondensedBlack"
    var strokeWidth = -4.0
    
    var font: UIFont {
        get {
            return UIFont(name: fontName, size: fontSize)!
        }
    }
    
    var textAttributes: [String: AnyObject] {
        get {
            return [NSStrokeColorAttributeName: strokeColor,
                    NSForegroundColorAttributeName:foregroundColor,
                    NSFontAttributeName: font,
                    NSStrokeWidthAttributeName: strokeWidth]
        }
    }
}