//
//  LoginViewController.swift
//  GroceryHelper
//
//  Created by user150278 on 5/22/19.
//  Copyright © 2019 user150278. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var signupView: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    @IBAction func segmentedControlClicked(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            signupView.isHidden = true
            loginView.isHidden = false
            print("login")
            break;
        case 1:
            signupView.isHidden = false
            loginView.isHidden = true
            print("sign up")
            break;
        default:
            break;
        }
    }
    
    @IBAction func logIn(_ sender: Any) {
        
    }
}
