//
//  BaseNavigationC.swift
//  
//
//  Created by 范东 on 2023/2/8.
//

import UIKit

open class BaseNavigationC: UINavigationController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.shadowImage = UIImage()
    }
    
    open override var shouldAutorotate: Bool {
        get {
            guard let last = viewControllers.last else { return false }
            return last.shouldAutorotate
        }
    }
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            guard let last = viewControllers.last else { return .allButUpsideDown }
            return last.supportedInterfaceOrientations
        }
    }
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        get {
            guard let last = viewControllers.last else { return UIApplication.shared.statusBarOrientation }
            return last.preferredInterfaceOrientationForPresentation
        }
    }
}
