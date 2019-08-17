//
//  CountryCode.swift
//  News
//
//  Created by fareselsokary on 8/15/19.
//  Copyright © 2019 Fares. All rights reserved.
//

import Foundation


// MARK: - CountryCodeElement
struct CountryCodeElement: Codable {
    let code, name: String?
    
    enum CodingKeys: String, CodingKey {
        case code = "Code"
        case name = "Name"
    }
}
