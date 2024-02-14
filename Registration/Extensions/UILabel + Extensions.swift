//
//  UILabel + Extensions.swift
//  Registration
//
//  Created by KOДИ on 14.02.2024.
//

import UIKit

extension UILabel {
    convenience init(text: String, font: UIFont) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
