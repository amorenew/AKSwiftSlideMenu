//
//  TabViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Amr Abd El Wahab on 12/15/15.
//  Copyright © 2015 Kode. All rights reserved.
//

import UIKit

class TabViewController: BaseTabViewController {
    override func viewDidLoad() {
        self.addSlideMenuButton("left")
        self.setNavigationTitle("Tab Title")
    }
}
