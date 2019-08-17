//
//  UIViewController.swift
//  News
//
//  Created by fareselsokary on 8/15/19.
//  Copyright © 2019 Fares. All rights reserved.
//

import NaturalLanguage
import UIKit
private var spinnerView = UIView()
//
extension UIViewController {
    // MARK: - add Spinner from view

    func showSpinner(onView: UIView) {
        spinnerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        spinnerView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.2)
        let ai = UIActivityIndicatorView(style: .whiteLarge)
        ai.color = .gray
        ai.startAnimating()
        ai.center = spinnerView.center

        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
    }

    // MARK: - remove Spinner from view

    func removeSpinner() {
        DispatchQueue.main.async {
            spinnerView.removeFromSuperview()
        }
    }

    // MARK: - add alert

    func AlertMessage(title: String, userMessage: String, complition: (() -> Void)? = nil) {
        let myAlert = UIAlertController(title: title, message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            complition?()
        })
        myAlert.addAction(okAction)
        present(myAlert, animated: true, completion: nil)
    }
}
