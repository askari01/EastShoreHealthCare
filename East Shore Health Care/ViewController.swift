//
//  ViewController.swift
//  East Shore Health Care
//
//  Created by Syed Askari on 7/6/17.
//  Copyright © 2017 Syed Askari. All rights reserved.
//

import UIKit
import WebKit
import SystemConfiguration

class ViewController: UIViewController, UIWebViewDelegate {

    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        webView = WKWebView()
        // configure WKWebView
        webView.isUserInteractionEnabled = true
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.bounces = true
        webView.scrollView.isScrollEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func viewDidAppear(_ animated: Bool) {
        if isConnectedToNetwork() {
            if let url = URL(string: "https://www.africakart.com") {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        } else {
            print ("no internet")
            let alertController = UIAlertController(title: "Error", message: "Bad Internet Found.", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            
            let reloadAction = UIAlertAction(title: "Reload", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                print("Reload")
                self.reload()
            }
            
            alertController.addAction(reloadAction)
            self.present(alertController, animated: true, completion:nil )
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                zeroSockAddress in SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)}
        } ) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == false {
            return false
        }
        
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired
        
        return isReachable && !needsConnection
        
    }
    
    func reload() {
        if isConnectedToNetwork() {
            if let url = URL(string: "https://www.africakart.com") {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        } else {
            print ("no internet")
            let alertController = UIAlertController(title: "Error", message: "Bad Internet Found.", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            
            let reloadAction = UIAlertAction(title: "Reload", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                print("Reload")
                self.reload()
            }
            
            alertController.addAction(reloadAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func refreshWebView() {
        // On Scroll to Refresh, Reload Current Page
        webView.reload()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // Display Progress Bar While Loading Pages
        if keyPath == "estimatedProgress" {
            print(Float(webView.estimatedProgress))
        }
    }
    
}

