//
//  Util.swift
//  ripLove
//
//  Created by 文　裕誠 on 2020/05/16.
//  Copyright © 2020 文　裕誠. All rights reserved.
//

import UIKit
import SCLAlertView

class Util: NSObject {
    
    /// awesomeフォントの絵文字を画像に変換します。
    static func awesomeImage(text: String, size: CGFloat, fontGroup: FontAwesomeType) -> UIImage {

        let font = UIFont(name: fontGroup.rawValue, size: size)
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        style.lineBreakMode = NSLineBreakMode.byClipping

        let attr : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : font,
                                                     NSAttributedString.Key.paragraphStyle: style,
                                                     NSAttributedString.Key.backgroundColor: UIColor.clear ]

        UIGraphicsBeginImageContextWithOptions(CGSize(width: size*1.3, height: size), false, 0)
        text.draw(in: CGRect(x: 0,
            y: 0,
            width: size*1.3,
            height: size),
            withAttributes: attr)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    /// ナビゲーションバーに表示する
    static func getNavigationTitle() -> UIImageView {
        var image = UIImage(named:"logo")
        let reSize = CGSize(width: image!.size.width * 0.8, height: image!.size.height * 0.8)
        image = image?.reSizeImage(reSize: reSize)
        return UIImageView(image: image)
    }
    
    // storyboard遷移
    static func gotoStroboard(storyBoardName: String) {
        
        let vc = UIStoryboard(name: storyBoardName, bundle: nil).instantiateInitialViewController()!
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
    
    static func showError() {
        SCLAlertView().showError("Hello Error", subTitle: "This is a more descriptive error text.") // Error
        SCLAlertView().showNotice("Hello Notice", subTitle: "This is a more descriptive notice text.") // Notice
        SCLAlertView().showWarning("Hello Warning", subTitle: "This is a more descriptive warning text.") // Warning
        SCLAlertView().showInfo("Hello Info", subTitle: "This is a more descriptive info text.") // Info
        SCLAlertView().showEdit("Hello Edit", subTitle: "This is a more descriptive info text.") // Edit
        SCLAlertView().showWait("Hello Wait", subTitle: "This is a more descriptive info text.") // Wait
    }
    
    static func showInfoDailog(title:String, subTitle:String){

       SCLAlertView().showInfo(title, subTitle: subTitle) // Info
    }
    
    static func dateFormatter(date: Date) -> String{
        let formatter  = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
}

extension UIImage {
    // resize image
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height));
        let reSizeImage:UIImage! = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
    // scale the image at rates
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
}
