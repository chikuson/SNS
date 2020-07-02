//
//  UD.swift
//  ripLove
//
//  Created by 文　裕誠 on 2020/05/15.
//  Copyright © 2020 文　裕誠. All rights reserved.
//

import UIKit

class UD: NSObject {

    private enum Key: String {

        case userName
        case age
        case approval
        case idfa
        case userPassword

    }

    private static let ud: UserDefaults = UserDefaults.standard
    //　ユーザーの名前
    static var userName: String {
        get { return ud.object(forKey: Key.userName.rawValue) as? String ?? "" }
        set(value) { ud.set(value, forKey: Key.userName.rawValue) }
    }
    // ユーザーの年齢
    static var age: Int {
        get { return ud.integer(forKey: Key.age.rawValue) }
        set(value) { ud.set(value, forKey: Key.age.rawValue) }
    }
    // データに保存
    static var userid: String? {
        get { return ud.string(forKey: Key.idfa.rawValue) }
        set(value) { ud.set(value, forKey: Key.idfa.rawValue) }
    }
    // ユーザーのパス
    static var userPassword: Int {
        get { return ud.integer(forKey: Key.userPassword.rawValue) }
        set(value) { ud.set(value, forKey: Key.userPassword.rawValue) }
    }

    static var approval: Bool {
        get { return ud.bool(forKey: Key.approval.rawValue) }
        set(value) { ud.set(value, forKey: Key.approval.rawValue) }
    }


}
