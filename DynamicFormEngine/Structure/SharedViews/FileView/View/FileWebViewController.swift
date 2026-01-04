//
//  FileWebViewController.swift
//  CERQEL
//
//  Created by ahmed maher on 20/09/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//


import UIKit
import WebKit

class FileWebViewController: BaseView<FileViewModel, BaseItem>, WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate {

    public var file: FileModel!

    @IBOutlet weak var downloadView: UIView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressView: UIProgressView!

    public enum PaymentStatus: String {
        case success = "payment-done"
        case failure = "payment-error"
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureWebView()
        viewModel = FileViewModel(router: CerqelRouterManagerDynamicFormImpl(self))
        viewModel.fileDownloaded.bind { isDownloaded in
            if (isDownloaded) {
                self.dismiss(animated: true)
            }
        }
    }

    private func configureUI() {
        self.activityIndicator.color = primaryMain
        self.activityIndicator.startAnimating()
        self.downloadView.backgroundColor = primaryMain
    }

    private func configureWebView() {

        webView.navigationDelegate = self
        webView.uiDelegate = self
        let autorizeFile = file.fileURl
        var request = URLRequest(url: autorizeFile.cerqel_toURL())
        
        request.allHTTPHeaderFields = globalHeaders
        webView.load(request)
        print(request)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.url), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.url), let urlString = webView.url?.absoluteString {

            print("### URL:", urlString)
        } else if keyPath == #keyPath(WKWebView.estimatedProgress) {
            print("### WKWebView.estimatedProgress = \(webView.estimatedProgress)")
        }
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("WKWebView Provisional navigation error: \(error.localizedDescription)")
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("WKWebView Navigation error: \(error.localizedDescription)")
        self.activityIndicator.stopAnimating()
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("WKWebView didStartProvisionalNavigation")
        self.activityIndicator.startAnimating()
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WKWebView didFinishNavigation")
        self.activityIndicator.stopAnimating()
    }

    @IBAction func download(_ sender: Any) {
        viewModel.downloadFile(file: file)
    }

}
