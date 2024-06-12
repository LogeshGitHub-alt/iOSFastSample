//
//  ViewController.swift
//  WebView
//
//  Created by vigneshwaranm on 21/09/23.
//

import UIKit
import WebKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var inlineErrorLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var webViewHolder: UIView!
    @IBAction func subButton(_ sender: Any) {
        loadEnglishURL()
    }
    
    @IBOutlet weak var arabicTextfield: UITextField!
    
    @IBAction func arabicButton(_ sender: UIButton) {
        loadArabicURL()
    }
    
    
    @IBAction func dismissWebView(_ sender: Any) {
        webViewHolder.isHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
#if DEBUG
       if #available(iOS 16.4, *) {
          webView.isInspectable = true
       }
#endif
        webViewHolder.isHidden = true
        self.textField.delegate = self
       
        // Do any additional setup after loading the view.
    }
    
    
    func loadEnglishURL() {
        guard let urlString = textField.text, let url = validateURL(urlString) else {
            inlineErrorLabel.text = "Invalid URL"
            return
        }
        
        inlineErrorLabel.text = ""
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        webViewHolder.isHidden = false
    }
    
    func loadArabicURL() {
        guard let urlString = arabicTextfield.text, let url = validateURL(urlString) else {
            inlineErrorLabel.text = "Invalid URL"
            return
        }
        
        inlineErrorLabel.text = ""
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        webViewHolder.isHidden = false
    }

    
    func validateURL(_ urlString: String) -> URL? {
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            // Valid URL
            return url
        } else {
            // Invalid URL
            return nil
        }
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.textField.resignFirstResponder()
        self.arabicTextfield.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        inlineErrorLabel.text = ""
    }
    
}

