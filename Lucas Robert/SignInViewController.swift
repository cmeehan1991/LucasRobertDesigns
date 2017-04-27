//
//  SignInViewController.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 1/13/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate, SignInProtocol{
    // Variables
    let defaults = UserDefaults.standard
    var signInModel = SignInModel()
    var loadingAlert : UIAlertController = UIAlertController()
    var loginAlert : UIAlertController = UIAlertController()
    
    // Connections
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    func itemsDownloaded(error: String, displayName: String, email: String, roles: NSArray, userID: String) {
        
        // Check if the user was able to sign in properly
        if(error == "NONE"){
            self.defaults.set(true, forKey: "IS_LOGGED_IN")
            self.defaults.set(displayName, forKey:"DISPLAY NAME")
            self.defaults.set(email, forKey: "EMAIL")
            self.defaults.set(roles, forKey:"ROLES")
            self.defaults.set(userID, forKey: "USER_ID")
            
            //After the user defaults have been set then navigate to the home screen
            let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let leftViewController = self.storyboard?.instantiateViewController(withIdentifier: "NavigationDrawerViewController") as! NavigationDrawerViewController
            let leftNavController = UINavigationController(rootViewController: leftViewController)
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.centerContainer!.centerViewController = centerNavController
            appDelegate.centerContainer!.leftDrawerViewController = leftNavController
        }else{ // There was an error meaning the user was not able to successfully log in.
            
            // Notify the user that there was an error and clear the password field.
            loginAlert = UIAlertController(title: "Error", message: "The username and password you entered do not match any of our records. Please try again.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler:{(alert: UIAlertAction!) in
                self.passwordTextField.text = ""
            })
            loginAlert.addAction(defaultAction)
            self.present(loginAlert, animated: true, completion: nil)
            print("Sign in error: \(error)")
        }
    }
    
    func userAuthentication(){
        self.signInModel.downloadItems(username: self.usernameTextField.text!, password: self.passwordTextField.text!)
        
    }
    
    @IBAction func userSignIn(){
        view.endEditing(true);
        userAuthentication()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch(textField.tag){
        case 0:
            usernameTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
            break
        case 1:
            passwordTextField.resignFirstResponder()
            self.view.endEditing(true)
            userAuthentication()
            break
        default:break
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
    
        self.signInModel.delegate = self
        
        self.navigationController?.isToolbarHidden = true
        self.navigationController?.isNavigationBarHidden = true
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
    }
}
