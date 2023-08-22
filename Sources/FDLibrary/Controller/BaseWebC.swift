//
//  FDWebController.swift
//  FDUIKit
//
//  Created by fandongtongxue on 2020/2/24.
//

import UIKit
import WebKit

open class BaseWebC : BaseVC {
    
    public var url: String = ""
    public var htmlString: String = ""
    
    open override func viewDidLoad() {
        view.addSubview(webView)
        if url.count > 0 {
            webView.load(URLRequest(url: URL(string: url)!))
        }else if htmlString.count > 0{
            webView.loadHTMLString(htmlString, baseURL: nil)
        }else{
            abort()
        }
    }
    
    public lazy var webView: WKWebView = {
        let jScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let wkUScript = WKUserScript(source: jScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let wkUController = WKUserContentController()
        wkUController.addUserScript(wkUScript)
        let wkWebConfig = WKWebViewConfiguration()
        wkWebConfig.userContentController = wkUController
        let webView = WKWebView(frame: view.bounds, configuration: wkWebConfig)
        webView.isOpaque = false
        webView.scrollView.bounces = false
        webView.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        webView.uiDelegate = self
        return webView
    }()
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if previousTraitCollection?.userInterfaceStyle == .dark {
            //字体颜色变白
            webView.evaluateJavaScript("document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#ffffff") { result, error in
                debugPrint(result)
                debugPrint(error)
            }
        }else{
            //字体颜色变黑
            webView.evaluateJavaScript("document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#333333") { result, error in
                debugPrint(result)
                debugPrint(error)
            }
        }
    }
}

extension BaseWebC: WKNavigationDelegate,WKUIDelegate{
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if url.count > 0 {
            title = webView.title
        }
        if UITraitCollection.current.userInterfaceStyle == .dark {
            webView.evaluateJavaScript("document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#ffffff") { result, error in
                debugPrint(result)
                debugPrint(error)
            }
        }else{
            webView.evaluateJavaScript("document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#333333") { result, error in
                debugPrint(result)
                debugPrint(error)
            }
        }
    }
}
