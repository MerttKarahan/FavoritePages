//
//  webServiceVC.swift
//  FavoritePages
//
//  Created by emn on 24.05.2022.
//

import UIKit
import WebKit
import Firebase

class WebVC: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    var webViewModel = WebViewModel()

    var enumType: WebType?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self

        switch enumType {
        case.add:
            requestForGoogle()
        case.preview(let urlString):
            requestForFavorite(url: urlString)
            buttonsStackView.isHidden = true
        default:
            break
        }
    
    }

    @IBAction func homeButton(_ sender: Any) {
        requestForGoogle()
    }
    
    @IBAction func addButton(_ sender: Any) {
        
        let currentUrl = self.webView.url?.absoluteString

        let alert = UIAlertController(title: "Save This Page", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { urlTextField in
            urlTextField.isEnabled = false
            urlTextField.text = currentUrl
        }
        alert.addTextField { titleTextField in
            titleTextField.placeholder = "Title.."
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        let saveButton = UIAlertAction(title: "Save This Page", style: UIAlertAction.Style.default) { action in
            let currentTitle = alert.textFields?[1].text
            self.webViewModel.addNewData(pageUrl: currentUrl, pageTitle: currentTitle) { error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: "Please try again")
                } else {
                    self.performSegue(withIdentifier: "toBackFavoriteList", sender: nil)
                }
            }
        }
        

        alert.addAction(saveButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true)
        
    }
    
    func requestForGoogle() {
        let url = URL(string:"https://www.google.com")
        let request = URLRequest(url: url!)
        webView.load(request)
        
    }
    
    func requestForFavorite(url: String) {
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
}


