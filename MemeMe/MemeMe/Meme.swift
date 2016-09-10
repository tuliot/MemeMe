//
//  Meme.swift
//  MemeMe
//
//  Created by Tulio Troncoso on 9/10/16.
//  Copyright © 2016 Tulio. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var name: String?
    var image: UIImage
    var topText: String?
    var bottomText: String?
    var memedImage: UIImage?
}

extension Meme: CustomStringConvertible {
    var description: String {
        if let n = name {
            return n
        }

        return "[Meme without name]"
    }
}

extension Meme: Equatable {}

func ==(lhs: Meme, rhs: Meme) -> Bool {

    if (lhs.name == rhs.name) {
        return true
    }

    if (lhs.image == rhs.image) {
        return true
    }

    return true
}

func !=(lhs: Meme, rhs: Meme) -> Bool {
    return !(lhs == rhs)
}
