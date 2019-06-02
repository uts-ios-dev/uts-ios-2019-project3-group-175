//
//  User.swift
//  GroceryHelper
//
//  Created by 谭泽宇 on 2/6/19.
//  Copyright © 2019 user150278. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    
    init(authData: Firebase.User) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}
