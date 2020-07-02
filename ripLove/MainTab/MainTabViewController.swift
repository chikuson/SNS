//
//  MainTabViewController.swift
//  ripLove
//
//  Created by 文　裕誠 on 2020/05/14.
//  Copyright © 2020 文　裕誠. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {

    static public var instance: MainTabViewController!
    
    enum tab {
        case Home
        case Matching
        case Message
        case option
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MainTabViewController.instance = self
        self.delegate = self as? UITabBarControllerDelegate
        
        tabSetup()
    }
    
    let TAB_MAIN_NUM = 0
    let TAB_MEET_NUM = 1
    let TAB_MESSAGE_NUM = 2
    let TAB_OPTION_NUM = 3
    
    func tabSetup() {

          
        var viewControllers: [UIViewController] = []
        
        var storyboard = UIStoryboard(name:  "Home", bundle: nil)
        var viewController: UIViewController! = storyboard.instantiateViewController(withIdentifier: "Home")
    
        viewController.tabBarItem = UITabBarItem(title: "ホーム", image: .checkmark, tag: 1)
        viewControllers.append(viewController)
        
        storyboard = UIStoryboard(name: "Matching", bundle: nil)
        viewController = storyboard.instantiateInitialViewController()
        viewController.tabBarItem = UITabBarItem(title: "出会う", image: .strokedCheckmark, tag: 1)
        viewControllers.append(viewController)
        
        storyboard = UIStoryboard(name: "ChatList", bundle: nil)
        viewController = storyboard.instantiateInitialViewController()
        viewController.tabBarItem = UITabBarItem(title: "メッセージ", image: .strokedCheckmark, tag: 1)
        viewControllers.append(viewController)
        
        storyboard = UIStoryboard(name: "Option", bundle: nil)
        viewController = storyboard.instantiateInitialViewController()
        viewController.tabBarItem = UITabBarItem(title: "設定", image: .strokedCheckmark, tag: 1)
        viewControllers.append(viewController)
        
        
        if #available(iOS 10.0, *) {
            self.tabBar.unselectedItemTintColor = UIColor.darkGray
        }
        
        self.tabBar.selectedImageTintColor = UIColor.brown
        self.tabBar.tintColorDidChange()
        
        //配列にいれたTabをセット
        setViewControllers(viewControllers, animated: false)
    }
}
