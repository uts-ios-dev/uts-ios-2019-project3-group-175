//
//  LoginViewController.swift
//  GroceryHelper2
//
//  Created by user150278 on 6/2/19.
//  Copyright © 2019 user150278. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var signupView: UIView!
    @IBOutlet weak var loginView: UIView!
   
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginPasswordTextfield: UITextField!
    @IBOutlet weak var loginEmailTextField: UITextField!
    
    
    
    /// Navigate between views in segmentedcontrol
    ///
    /// - Parameter sender: UISegmentedcontrol
    @IBAction func segmentedControlClicked(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            signupView.isHidden = true
            loginView.isHidden = false
            break;
        case 1:
            signupView.isHidden = false
            loginView.isHidden = true
            break;
        default:
            break;
        }
    }
    
    
    /// Logs in a user if details are valid
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func logIn(_ sender: Any) {
        // If any of the textfields are empty show alert66
        if self.loginEmailTextField.text == "" || self.loginPasswordTextfield.text == "" {
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().signIn(withEmail: self.loginEmailTextField.text!, password: self.loginPasswordTextfield.text!) { (user, error) in
                // If sign in successful go to profle
                if error == nil {
                    print("You have successfully logged in")
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "profile")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    // Tells the user that there is an error and shows error msg from firebase
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    /// Creates user account
    ///
    /// - Parameter sender:
    @IBAction func createAccount(_ sender: Any) {
        // Shows alert with errormsg if any textfield are empty
        if emailTextField.text == "" || passwordTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        else {
            // Creates user
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                // If sign up is successfull go to profile
                if error == nil {
                    print("Successfully signed up")
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "profile")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    // If signup unsuccessful show errormsg
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}

