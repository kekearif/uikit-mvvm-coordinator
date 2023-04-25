//
//  ViewController.swift
//  uikit-mvvm-coordinator-demo
//
//  Created by Keke Arif on 2023/4/25.
//

import UIKit

class ViewController: UIViewController {

    var deinitNotificationName: NSNotification.Name {
        let name = "\(String(describing: self.classForCoder)).deinit"

        return NSNotification.Name(rawValue: name)
    }

    deinit {
        NotificationCenter.default.post(name: deinitNotificationName, object: self)
    }

}
