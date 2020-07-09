//
//  chatRoomModel.swift
//  ripLove
//
//  Created by 文　裕誠 on 2020/07/09.
//  Copyright © 2020 文　裕誠. All rights reserved.
//

import Foundation
import Firebase

class ChatRoomModel {
    
    let laseMessageId: String
    let members: [String]
    let createdAt: Timestamp
    
    var partnerUser: AppUser?
    
    init(dic: [String : Any]) {
        self.laseMessageId = dic["laseMessageId"] as? String ?? ""
        self.members = dic["members"] as? [String] ?? [String]()
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
}
