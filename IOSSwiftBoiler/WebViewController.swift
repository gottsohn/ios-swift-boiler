//
//  WebViewController.swift
//  ios swift boiler
//
//  Created by Godson Ukpere on 3/14/16.
//  Copyright © 2016 Godson Ukpere. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var titleView: UINavigationItem!
    
    var url:String!
    var labelText:String!
    var timer:NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        if url != nil {
            webView.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
            titleView.title = labelText
        }
    }
    
    func timerCallback() {
        if progressView.progress < 0.9 {
            progressView.progress += 0.005
        }
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        progressView.progress = 0.0
        progressView.hidden = false
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        doneLoading()
    }
    
    func doneLoading() {
        progressView.progress = 1.0
        progressView.hidden = true
        timer?.invalidate()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        if error != nil {
            doneLoading()
            Helpers.showError(self, error: error!)
        }
    }
}
