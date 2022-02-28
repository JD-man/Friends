//
//  UIViewController+Ext.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/23.
//

import UIKit

extension UIViewController {
    var topVC: UIViewController {
        return self.topVC(currentViewController: self)
    }
    
    func topVC(currentViewController: UIViewController) -> UIViewController {
        if let tabBarController = currentViewController as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            return self.topVC(currentViewController: selectedViewController)
        } else if let navigationController = currentViewController as? UINavigationController,
                  let visibleViewController = navigationController.visibleViewController {
            return self.topVC(currentViewController: visibleViewController)
        } else if let presentedViewController = currentViewController.presentedViewController {
            return self.topVC(currentViewController: presentedViewController)
        } else {
            return currentViewController
        }
    }
}
