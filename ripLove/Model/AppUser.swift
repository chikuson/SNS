//
//  APPUser.swift
//  ripLove
//
//  Created by 文　裕誠 on 2020/05/18.
//  Copyright © 2020 文　裕誠. All rights reserved.
//

import Foundation
import Firebase

class AppUser {
    let userID: String //FirebaseAuthのuserid
    let password: String
    let userName: String //uername
    let country: String
    let age: String
    var url: String = "image" //　画像URL
    let email: String // email
    let createdAt: Timestamp //ユーザー登録日
    
    var uid: String?

    init(data: [String: Any]) {
        userID = data["userID"] as? String ?? ""
        password = data["password"] as? String ?? ""
        userName = data["userName"] as? String ?? ""
        country = data["country"] as? String ?? ""
        age = data["age"] as? String ?? ""
        url = data["url"] as? String ?? ""
        createdAt = data["createdAt"] as! Timestamp
        email = data["email"] as? String ?? ""
    }
}
