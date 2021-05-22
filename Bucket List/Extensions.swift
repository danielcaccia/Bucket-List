//
//  Extensions.swift
//  Bucket List
//
//  Created by Daniel Caccia on 23/05/21.
//

import UIKit

extension UITextField {

    var isEmpty: Bool {
        return text?.trimmingCharacters(in: .whitespaces) == ""
    }
    
}

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
}
