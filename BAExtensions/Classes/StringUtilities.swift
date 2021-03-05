//
//  StringUtilities.swift
//  BAExtensions
//
//  Created by Betto Akkara on 04/02/21.
//

import Foundation
import UIKit

extension String {
    public func rangeFromNSRange(_ nsRange : NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
    public func capitalizingFirstLetter() -> String {
        let first = String(self.prefix(1)).capitalized
        let other = String(self.dropFirst())
        return first + other
    }
    public func toFloat() -> Float {
        let floatString = Float(self)
        return floatString ?? 0.0
    }
    mutating public func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }

}
