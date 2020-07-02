//
//  Date.swift
//  ripLove
//
//  Created by 文　裕誠 on 2020/05/16.
//  Copyright © 2020 文　裕誠. All rights reserved.
//

import Foundation

extension Date {
    
    /// 今日か判定します。
    /// @return 今日の場合 YES を返します。
    func isToday() -> Bool {

        let formatTemplate = "yyyy/MM/dd"
        let dateString = stringFromDateWithTemplate(formatTemplate: formatTemplate)
        let todayString = Date().stringFromDateWithTemplate(formatTemplate: formatTemplate)

        if dateString == todayString {
            return true
        }
        else {
            return false
        }
    }
    
    /// 端末の設定を変えても日本時間で計算する
    /// 比較対象となる時刻は呼ぶ先で何も設定しなくて良し
    func isTodayInJST() -> Bool {
        
        let components = Calendar(identifier: .gregorian).dateComponents(in: TimeZone(identifier: "Asia/Tokyo")!, from: self)
        let components2 = Calendar(identifier: .gregorian).dateComponents(in: TimeZone(identifier: "Asia/Tokyo")!, from: Date())
        
        guard let day = components.day, let day2 = components2.day else {
            return false
        }
        
        if day == day2 {
            return true
        }
        else {
            return false
        }
    }

    /**
     *  指定した日時フォーマットで NSString に変換します。
     */
    func stringFromDateWithTemplate(formatTemplate: String) -> String {

        let formatter = DateFormatter()
        let calendar = Calendar(identifier: .gregorian)
        formatter.locale = NSLocale.system
        formatter.calendar = calendar
        formatter.dateFormat = formatTemplate

        return formatter.string(from: self)
    }
    
    // 標準時刻(+0000)のDateに+9時間の補正を行った文字列を返します
    static func dateString(date: Date)-> String? {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier:APP_TIME_ZONE)
        dateFormatter.locale = Locale(identifier: APP_LOCALE)
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    // 文字列を変換して標準時刻(+0000)のDateを返します
    static func date(date: String)-> Date? {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier:APP_TIME_ZONE)
        dateFormatter.locale = Locale(identifier: APP_LOCALE)
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return dateFormatter.date(from: date)
    }
}
