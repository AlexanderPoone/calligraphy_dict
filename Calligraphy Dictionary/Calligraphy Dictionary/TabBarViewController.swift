//
//  TabBarViewController.swift
//  Calligraphy Dictionary
//
//  Created by Victor Poon on 4/11/2019.
//  Copyright © 2019 SoftFeta. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.items![0].title = NSLocalizedString("cursive_script", comment: "")
        tabBar.items![1].title = NSLocalizedString("small_seal_script", comment: "")
        tabBar.items![2].title = NSLocalizedString("title_favourites", comment: "")
        tabBar.items![3].title = NSLocalizedString("title_history", comment: "")
        tabBar.items![4].title = NSLocalizedString("title_settings", comment: "")
//        tabBar.items![5].title = NSLocalizedString("s_conversion", comment: "")
        // Do any additional setup after loading the view.
    }
        

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
