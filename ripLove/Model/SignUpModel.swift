//
//  SignUpModel.swift
//  ripLove
//
//  Created by 文　裕誠 on 2020/07/05.
//  Copyright © 2020 文　裕誠. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class SignUpModel {
    private let userNameSubject = PublishSubject<String>()
    private let passwordSubject = PublishSubject<String>()
    private let mailSubject = PublishSubject<String>()
    private let isTappedRegisterButtonSubject = BehaviorSubject(value: false)
    
    var password: Observable<String> {
        return passwordSubject
    }
    var userName: Observable<String> {
        return userNameSubject
    }
    var mail: Observable<String> {
        return mailSubject
    }
    
    var isTappedRegisterButton: Observable<Bool> {
        return isTappedRegisterButtonSubject
    }
    
    func setUserRegisterInfo(userNameText: String,passwordText :String ,mailText:String){
        userNameSubject.onNext(userNameText)
        passwordSubject.onNext(passwordText)
        mailSubject.onNext(mailText)
    }
    
    func isEnableButton(){
        isTappedRegisterButtonSubject.onNext(false)
    }
}
