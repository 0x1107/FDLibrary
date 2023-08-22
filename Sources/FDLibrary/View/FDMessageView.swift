//
//  FDMessageView.swift
//  FDUIKit
//
//  Created by Mac on 2021/9/30.
//

import UIKit
import SwiftMessages

open class FDMessageView: NSObject {
    public class func show(title: String, message: String, theme: Theme){
        let view: MessageView
        view = MessageView.viewFromNib(layout: .cardView)
        
        view.configureContent(title: title, body: message, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: NSLocalizedString("I know", comment: ""), buttonTapHandler: { _ in SwiftMessages.hide() })

        let iconStyle = IconStyle.light
        
        view.configureTheme(theme, iconStyle: iconStyle)
        
        view.configureDropShadow()
        
        // Config setup
        
        var config = SwiftMessages.defaultConfig
        
        config.presentationStyle = .bottom
        
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        
        config.duration = .seconds(seconds: 3)
        
        config.dimMode = .gray(interactive: true)

        config.shouldAutorotate = true
        
        config.interactiveHide = true
        
        config.preferredStatusBarStyle = .lightContent
        
        // Show
        SwiftMessages.show(config: config, view: view)
    }
}
