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
    
    var linkURL : URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.webView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let link = linkURL {
            print(link)
            let myRequest = URLRequest(url: link)
            webView.load(myRequest)
        }
    }

}
