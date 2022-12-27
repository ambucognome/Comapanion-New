//
//  WebViewController.swift
//  Compan
//
//  Created by Ambu Sangoli on 16/12/22.
//

import UIKit
import WebKit

class WebViewController: UIViewController,WKNavigationDelegate {
    
    var webView: WKWebView!
    var url = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
    }
    

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setupWebView()
    }
    

    func setupWebView(){
        ERProgressHud.shared.show()
        let myURL = URL(string:self.url)
        let requests = NSURLRequest(url: myURL!)
        
        let frame = CGRect(x: self.view.frame.origin.x, y: self.topbarHeight , width: self.view.frame.width, height: self.view.frame.height)
        webView = WKWebView(frame: frame)
        
        webView.load(requests as URLRequest)
        ERProgressHud.shared.show()
        webView.navigationDelegate = self
        self.view.addSubview(webView)
    
    }
    
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ERProgressHud.shared.hide()
    }

}

extension UIViewController {

    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */

    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}
