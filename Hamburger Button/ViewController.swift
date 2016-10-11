//
//  ViewController.swift
//  Hamburger Button
//
//  Created by Robert Böhnke on 02/07/14.
//  Copyright (c) 2014 Robert Böhnke. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var button: HamburgerButton! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 38.0 / 255, green: 151.0 / 255, blue: 68.0 / 255, alpha: 1)

        self.button = HamburgerButton(frame: CGRect(x: 133, y: 133, width: 54, height: 54))
        self.button.addTarget(self, action: #selector(ViewController.toggle(_:)), for:.touchUpInside)

        self.view.addSubview(button)
    }

    override var preferredStatusBarStyle : UIStatusBarStyle  {
        return .lightContent
    }

    func toggle(_ sender: AnyObject!) {
        self.button.showsMenu = !self.button.showsMenu
    }
}

