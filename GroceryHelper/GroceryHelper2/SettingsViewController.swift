//
//  SettingsViewController.swift
//  GroceryHelper2
//
//  Created by user150278 on 6/2/19.
//  Copyright © 2019 user150278. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
   
    @IBOutlet weak var pwdTextFieldOne: UITextField!
    @IBOutlet weak var pwdTextFieldTwo: UITextField!
    @IBOutlet weak var currentPwd: UITextField!
    
    
    /// Change a users password
    ///
    /// - Parameter sender: any
    @IBAction func changePassword(_ sender: Any) {
        // Get current user and verify credentials
        let user = Auth.auth().currentUser
        let credential: AuthCredential = EmailAuthProvider.credential(withEmail: (user?.email)!, password: currentPwd.text!)
        
        if pwdTextFieldOne.text == pwdTextFieldTwo.text && !(pwdTextFieldOne.text!.isEmpty) {
            // Reauthenticate with credentials and update to new password
            user?.reauthenticate(with: credential, completion: nil)
            user?.updatePassword(to: pwdTextFieldOne.text!, completion: nil)
            print("Password changes successfully")
            
            // Alert to verify password changed
            let alertController = UIAlertController(title: "", message: "Password changed.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
                
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    /// Log out user
    @IBAction func logOut(sender: AnyObject) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "login")
                present(vc!, animated: true, completion: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    /// Deletes account
    @IBAction func deleteAccount(_ sender: Any) {
        let msg = UIAlertController(title: "Confirm", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            self.removeAccount()
        } )
        let no = UIAlertAction(title: "No", style: .default, handler:{ (action) -> Void in
        } )
        
        msg.addAction(yes)
        msg.addAction(no)
        
        self.present(msg, animated: true, completion: nil)
    }
    
    /// Deletes account of current user and go to Login page
    func removeAccount() {
        let user = Auth.auth().currentUser
        if user != nil {
            user?.delete(completion: nil)
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "login")
        self.present(vc!, animated: true, completion: nil)
    }
}
