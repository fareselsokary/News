//
//  customAlertViewController.swift
//  News
//
//  Created by fareselsokary on 8/17/19.
//  Copyright © 2019 Fares. All rights reserved.
//

import UIKit

class customAlertViewController: UIViewController {
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var dialogLbl: UILabel!

    var dialog = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }

    private func setupView() {
        dialogLbl.text = dialog
        mainView.layer.cornerRadius = 9
        mainView.clipsToBounds = true
    }

    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
