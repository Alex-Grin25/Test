//
//  WebAuthViewController.swift
//  SNApp
//
//  Created by ALEKSANDR GRIGOREV on 24.02.2021.
//

import UIKit
import WebKit

class WebAuthViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self

        // Do any additional setup after loading the view.
        if let url = URL(string: "https://oauth.vk.com/authorize?client_id=7771311&display=page&redirect_uri=https://oauth.vk.com/blank.html&scope=wall,friends,groups,photos&response_type=token&v=5.52") {
        let request = URLRequest(url: url)
        webView.load(request)
        }
        else {
            print("Invalid URL string")
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Load page finished: \(webView.url?.absoluteString)");
        if let urlString = webView.url?.absoluteString {
            if urlString.hasPrefix("https://oauth.vk.com/blank.html#") && urlString.contains("token=") {
                let index = urlString.index(urlString.startIndex, offsetBy: 45)
                var token = urlString[index...urlString.firstIndex(of: "&")!]
                token.removeLast()
                var user_id = urlString[urlString.lastIndex(of: "=")!...]
                user_id.removeFirst()
                
                Session.instance.token = String(token)
                Session.instance.userId = String(user_id)
                
                showNextVC()
            }
        }
    }
    
    func showNextVC() {
        if let vc = self.storyboard?.instantiateViewController(identifier: "Main") {
            //let vc = FirstTableViewController()
            //self.navigationController?.show(vc, sender: self)
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.navigationController?.setViewControllers([vc], animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
