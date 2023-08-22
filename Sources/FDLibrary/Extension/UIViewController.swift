//
//  SRM+UIViewController.swift
//  intl
//
//  Created by 0x1107 on 2023/4/18.
//

import Foundation
import UIKit

public extension UIViewController {
    func showAlert(title: String?, message: String?, preferredStyle: UIAlertController.Style, actionTitle:String?, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: handler))
        present(alert, animated: true)
    }
}
