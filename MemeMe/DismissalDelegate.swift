//
//  DismissalDelegate.swift
//  MemeMe
//
//  Created by Paul Crompton on 9/11/16.
//  Copyright © 2016 Paul Crompton. All rights reserved.
//

import Foundation
import UIKit

protocol DismissalDelegate {
    func dismissAndPresentNew(VCToDismiss: MemeDetailViewController, VCToPresent: MemeEditorViewController);
}
