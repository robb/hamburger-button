//
//  ViewController.swift
//  Hamburger Button
//
//  Created by Robert Böhnke on 02/07/14.
//  Copyright (c) 2014 Robert Böhnke
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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

