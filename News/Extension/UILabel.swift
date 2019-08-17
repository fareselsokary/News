//
//  UILabel.swift
//  News
//
//  Created by fareselsokary on 8/15/19.
//  Copyright © 2019 Fares. All rights reserved.
//

import UIKit
extension UILabel {
    func detectLanguage<T: StringProtocol>(for text: T) {
        let tagger = NSLinguisticTagger(tagSchemes: [.language], options: 0)

        tagger.string = String(text)

        guard let languageCode = tagger.tag(at: 0, scheme: .language, tokenRange: nil, sentenceRange: nil) else { return }

        if Locale.current.localizedString(forIdentifier: languageCode.rawValue) == "Arabic" {
            textAlignment = .right
        }
    }
}
