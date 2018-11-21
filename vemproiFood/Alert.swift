//
//  Alert.swift
//  vemproiFood
//
//  Created by Adriano Paladini on 21/11/18.
//  Copyright © 2018 Adriano Paladini. All rights reserved.
//

import UIKit

struct Alert {
    static func ok(title: String,
                   message: String,
                   okButtonTitle: String? = "Ok",
                   completion: (() -> Void)? = {}) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okButtonTitle, style: .default, handler: { _ in completion?() })

        alert.addAction(okAction)

        return alert
    }
    static func askDestruction(title: String,
                               message: String,
                               okBtnTitle: String? = "Yes",
                               cancelBtnTitle: String? = "No",
                               completion: ((Bool) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yesButton = UIAlertAction(title: okBtnTitle, style: .destructive, handler: { _ in completion?(true) })
        let noButton = UIAlertAction(title: cancelBtnTitle, style: .default, handler: { _ in completion?(false) })
        alert.addAction(noButton)
        alert.addAction(yesButton)
        alert.preferredAction = yesButton
        return alert
    }

    static func confirm(title: String?,
                        message: String?,
                        handler: @escaping (Bool) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: { _ in handler(true) })
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in handler(false) })
        alert.addAction(okBtn)
        alert.addAction(cancelBtn)
        alert.preferredAction = okBtn
        return alert
    }
}

extension UIAlertController {
    public func show() {
        var viewController = UIViewController()
        if let rootVC =  UIApplication.shared.delegate?.window??.rootViewController {
            viewController = rootVC
            var presented = rootVC
            while let top = presented.presentedViewController {
                presented = top
                viewController = top
            }
            viewController.present(self, animated: true, completion: nil)
        }
    }
}

