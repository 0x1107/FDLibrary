//
//  SRM+UIButton.swift
//  srm
//
//  Created by 范东 on 2023/2/13.
//

import UIKit

public extension UIButton {
    class func createBtn(title: String? = "", titleColor: UIColor? = .systemBackground, image: UIImage? = nil, backgroundColor: UIColor? = .systemBackground, font: UIFont? = .systemFont(ofSize: 14)) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.setImage(image, for: .normal)
        btn.setTitleColor(titleColor, for: .normal)
        btn.backgroundColor = backgroundColor
        btn.titleLabel?.font = font
        return btn
    }
}
