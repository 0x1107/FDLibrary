//
//  BaseVM.swift
//  Safebox
//
//  Created by 0x1107 on 2023/7/26.
//

import UIKit
import Toast
import RxSwift
import RxCocoa

public enum VMActionType {
    case activity(isEnabled: Bool, hasLoading: Bool = true)
    case show(msg: String?, position: ToastPosition = ToastPosition.bottom)
    case push(vc: UIViewController, animated: Bool)
    case popViewController(animated: Bool)
    case popToViewController(_ viewController: UIViewController, animated: Bool)
    case popToRootViewController(animated: Bool)
    case present(vc: UIViewController, animated: Bool, completion: (() -> Void)? = nil)
    case dismiss(animated: Bool, completion: (() -> Void)? = nil)
}

open class BaseVM: NSObject {
    open lazy var disposeBag = DisposeBag()
    open lazy var actionPS = PublishSubject<VMActionType>()
    
    deinit {
#if DEBUG
        print("deinit: \(type(of: self))")
#endif
    }
    public override init() {
        super.init()
#if DEBUG
        print("init: \(type(of: self))")
#endif
    }
}
