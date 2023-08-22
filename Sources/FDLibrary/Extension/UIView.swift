//
//  SRM+UIView.swift
//  srm
//
//  Created by 0x1107 on 2023/3/15.
//

import Foundation
import UIKit
import Toast

public extension UIView {
    func addRectCorner(cornerRadius: CGFloat = 10, corners: UIRectCorner = .allCorners, borderColor: UIColor? = nil, borderWidth: CGFloat = 1) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        if borderColor != nil {
            maskLayer.strokeColor = borderColor?.cgColor
            maskLayer.lineWidth = borderWidth
        }
        self.layer.mask = maskLayer
    }
    
    /// 创建并呈现一个新的 toast 视图。
    /// - Parameters:
    ///   - message: 要显示的消息
    ///   - duration: 吐司持续时间 默认 ToastManager.shared.duration
    ///   - position: 吐司的位置 默认 ToastManager.shared.position
    ///   - title: 标题 默认 nil
    ///   - image: 图片 默认 nil
    ///   - style: 样式。 当 nil 时将使用共享样式 默认 ToastManager.shared.style
    ///   - completion: 完成关闭，在 toast 视图消失后执行。如果 toast 视图从点击中消失，则 didTap 将为“true”。
    func fdToast(_ message: String?,
                 duration: TimeInterval = ToastManager.shared.duration,
                 position: ToastPosition = ToastManager.shared.position,
                 title: String? = nil,
                 image: UIImage? = nil,
                 style: ToastStyle = ToastManager.shared.style,
                 completion: ((_ didTap: Bool) -> Void)? = nil) {
        guard let message = message, message.count > 0 else { return }
        hideToast()
        makeToast(message, duration: duration, position: position, title: title, image: image, style: style, completion: completion)
    }
    
    class func createView(backgroundColor: UIColor? = .white) -> UIView{
        let view = UIView()
        view.backgroundColor = backgroundColor
        return view
    }
    
    func makeCenterToast(msg: String?) {
        var style = ToastStyle()
        style.titleFont = .boldSystemFont(ofSize: 20)
        fdToast(msg, position: .center, style: style)
    }
}
