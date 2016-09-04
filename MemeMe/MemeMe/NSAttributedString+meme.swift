//
//  NSAttributedString+meme.swift
//  MemeMe
//
//  Created by Tulio Troncoso on 9/3/16.
//  Copyright © 2016 Tulio. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {

    static func memeAttributes() -> [String : AnyObject] {

        return [
            NSFontAttributeName : UIFont(name:"HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSStrokeWidthAttributeName : NSNumber(float: -3.0),
            NSForegroundColorAttributeName : UIColor.whiteColor()
        ]
    }
}