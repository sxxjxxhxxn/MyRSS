//
//  RSSWebViewController.swift
//  MyRSS
//
//  Created by 서재훈 on 2020/03/19.
//  Copyright © 2020 서재훈. All rights reserved.
//

import UIKit
import WebKit

class RSSWebViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var linkURL : URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.webView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let link = linkURL {
            let myRequest = URLRequest(url: link)
            webView.load(myRequest)
            progressView.progress = 0.0
            webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        progressView.isHidden = webView.estimatedProgress == 1
    }

}
