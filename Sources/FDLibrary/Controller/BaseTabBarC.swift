//
//  BaseTabBarC.swift
//  FDUIKit
//
//  Created by 0x1107 on 2023/5/19.
//

import UIKit
import RxSwift

open class BaseTabBarC: UITabBarController {
    
    public var disposeBag = DisposeBag()

    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    public func createSubVC(vc: BaseVC, title: String, imageName: String, selImageName: String) -> BaseNavigationC {
        let nav = BaseNavigationC(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: imageName), selectedImage: UIImage(systemName: selImageName))
        return nav
    }
    
    open override var shouldAutorotate: Bool {
        guard let vc = selectedViewController else { return false }
        return vc.shouldAutorotate
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        guard let vc = selectedViewController else { return .allButUpsideDown }
        return vc.supportedInterfaceOrientations
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        guard let vc = selectedViewController else { return UIApplication.shared.statusBarOrientation }
        return vc.preferredInterfaceOrientationForPresentation
    }

}
