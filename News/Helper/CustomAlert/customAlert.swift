//
//  customAlert.swift
//  News
//
//  Created by fareselsokary on 8/17/19.
//  Copyright © 2019 Fares. All rights reserved.
//

import UIKit

class customAlert {
    static func alert(title: String) -> customAlertViewController {
        let storyboard = UIStoryboard(name: "alertStoryboard", bundle: nil)
        let vcAlert = storyboard.instantiateViewController(withIdentifier: "customAlertViewController") as! customAlertViewController
        vcAlert.dialog = title
        return vcAlert
    }
}
