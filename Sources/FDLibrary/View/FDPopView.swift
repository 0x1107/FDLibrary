//
//  FDPopView.swift
//  FDLiveKit
//
//  Created by fandongtongxue on 2020/8/25.
//

import UIKit

public enum FDPopType {
    case bottom
    case center
}

open class FDPopView: UIView {
    
    var type: FDPopType = .bottom
    
    public var hideWhenClickBack = false
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.origin.y = .screenH
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func show(_ containView : UIView, _ type : FDPopType) {
        self.type = type
        containView.addSubview(shadowView)
        containView.addSubview(self)
        if type == .bottom {
            let offsetY = containView.frame.size.height - self.frame.size.height
            UIView.animate(withDuration: 0.25) {
                self.frame = CGRect.init(x: self.frame.origin.x, y: offsetY, width: self.frame.size.width, height: self.frame.size.height)
                self.shadowView.alpha = 1
            }
        }else{
            let offsetY = (containView.frame.size.height - self.frame.size.height) / 2
            containView.addSubview(self.shadowView)
            containView.addSubview(self)
            transform = CGAffineTransformMakeScale(0.6, 0.6)
            UIView.animate(withDuration: 0.25) {
                self.transform = .identity
                self.shadowView.alpha = 1
                self.frame = CGRect.init(x: self.frame.origin.x, y: offsetY, width: self.frame.size.width, height: self.frame.size.height)
            }
        }
        
    }
    
    @objc public func hide() {
        if type == .bottom {
            UIView.animate(withDuration: 0.25, animations: {
                self.shadowView.alpha = 0
                self.frame = CGRect.init(x: self.frame.origin.x, y: self.superview?.frame.size.height ?? 0, width: self.frame.size.width, height: self.frame.size.height)
            }) { (finish) in
                self.shadowView.removeFromSuperview()
                self.removeFromSuperview()
            }
        }else{
            UIView.animate(withDuration: 0.25, animations: {
                self.shadowView.alpha = 0
                self.transform = CGAffineTransformMakeScale(0.01, 0.01)
            }) { (finish) in
                self.transform = .identity
                self.shadowView.removeFromSuperview()
                self.removeFromSuperview()
            }
        }
    }
    
    @objc func tapBack() {
        if hideWhenClickBack {
            hide()
        }
    }
    
    lazy var shadowView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: .screenW, height: .screenH))
        view.backgroundColor = .black.withAlphaComponent(0.55)
        view.alpha = 0
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(FDPopView.tapBack))
        view.addGestureRecognizer(tap)
        return view
    }()
}
