//
//  ViewController.swift
//  FavoritePages
//
//  Created by emn on 24.05.2022.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    private let loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.passwordText.isSecureTextEntry = true
    }

    @IBAction func signInButton(_ sender: Any) {
        loginViewModel.signInButtonClicked(email: emailText.text, password: passwordText.text) { err in
            self.segue(error: err)
        }
    }
    
    @IBAction func registerButton(_ sender: Any) {
        loginViewModel.registerButtonClicked(email: emailText.text, password: passwordText.text) { err in
            self.segue(error: err)
        }
    }
    
    func segue(error:String?) {
        if let error = error {
            self.makeAlert(titleInput: "Error", messageInput: error)
        } else {
            self.performSegue(withIdentifier: "toFavoriteList", sender: nil)
        }
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

