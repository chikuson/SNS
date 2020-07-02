//
//  OptionViewController.swift
//  ripLove
//
//  Created by 文　裕誠 on 2020/05/13.
//  Copyright © 2020 文　裕誠. All rights reserved.
//

import UIKit
import SCLAlertView
class OptionViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {

            if indexPath.row == 0 {

                let storyboard = UIStoryboard( name: "Mypage", bundle: nil )
                let vc = storyboard.instantiateInitialViewController()!
                navigationItem.titleView?.tintColor = UIColor.blue
                navigationController?.pushViewController( vc, animated: true )
            }
        }
            
        else if indexPath.section == 1 {
            
            
        }
            
        else if indexPath.section == 2 {
            
            
            
        }
    }
}
