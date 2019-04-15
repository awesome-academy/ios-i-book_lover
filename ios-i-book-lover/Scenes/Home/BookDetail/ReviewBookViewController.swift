//
//  ReviewBookViewController.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/12/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Reusable
import WebKit
import Then

final class ReviewBookViewController: UIViewController {
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var loadingLabel: UILabel!
    
    var bookISBN = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        guard let url = URL(string: "\(Configuration.reviewUrl)&isbn=\(bookISBN)") else
        {
            return
        }
        webView.do {
            $0.navigationDelegate = self
            $0.load(URLRequest(url: url))
        }
    }
}

extension ReviewBookViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: IndicatorChild.review)
    }
}

extension ReviewBookViewController: StoryboardSceneBased {
    static let sceneStoryboard = Storyboards.home
}

extension ReviewBookViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingLabel.text = ""
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let trust = challenge.protectionSpace.serverTrust else { return }
        let exceptions = SecTrustCopyExceptions(trust)
        SecTrustSetExceptions(trust, exceptions)
        completionHandler(.useCredential, URLCredential(trust: trust))
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if webView != self.webView {
            decisionHandler(.allow)
            return
        }
        
        let app = UIApplication.shared
        if let url = navigationAction.request.url {
            if navigationAction.targetFrame == nil {
                if app.canOpenURL(url) {
                    app.open(url, options: [:]) { (_) in
                    }
                    
                    decisionHandler(.cancel)
                    return
                }
            }
            decisionHandler(.allow)
        }
    }
}
