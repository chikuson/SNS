//
//  MessageModel.swift
//  ripLove
//
//  Created by 文　裕誠 on 2020/07/10.
//  Copyright © 2020 文　裕誠. All rights reserved.
//

import Foundation
import Firebase

class MessageModel {
    
    let name: String
    let message: String
    let uid: String
    let createdAt: Timestamp
    
    init(dic:[String: Any]) {
        self.name = dic["name"] as? String ?? ""
        self.message = dic["message"] as? String ?? ""
        self.uid = dic["uid"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
}
