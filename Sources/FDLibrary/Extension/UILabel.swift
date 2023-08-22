//
//  UILabel.swift
//  Safebox
//
//  Created by 0x1107 on 2023/7/13.
//

import Foundation
import UIKit

public extension UILabel {
    class func createLabel(font: UIFont? = .systemFont(ofSize: 20), numberOfLines: Int = 1, textColor: UIColor? = UIColor(red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1), text: String? = "UILabel", textAligment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.font = font
        label.numberOfLines = numberOfLines
        label.textColor = textColor
        label.text = text
        label.textAlignment = textAligment
        return label
    }
}
