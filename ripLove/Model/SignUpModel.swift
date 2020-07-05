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
    
    var password: Observable<String> {
        return passwordSubject
    }
    
    private let passwordSubject = PublishSubject<String>()
    
    func set(text: String) {
        passwordSubject.onNext(text)
    }
    
}
