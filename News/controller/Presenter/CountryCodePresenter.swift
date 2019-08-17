//
//  CountryCodePresenter.swift
//  News
//
//  Created by fareselsokary on 8/15/19.
//  Copyright © 2019 Fares. All rights reserved.
//

import Foundation
import Moya

// MARK: - Country Code Presenter Delegate

protocol CountryCodePresenterDelegate: class {
    func CountryCode(code: [CountryCodeElement])
    func showProgressLoader()
    func hideProgressLoader()
    func showError(error: Error)
}

class CountryCodePresenter {
    weak var delegate: CountryCodePresenterDelegate?
    private let newsProvider = MoyaProvider<newsServices>()
    // TODO: - get Country Code from api
    func getCountryCode() {
        delegate?.showProgressLoader()
        newsProvider.request(.countryCode) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                // success state
                case let .success(response):
                    // convert json data to data model ande pass it to Country Code delegate func
                    do {
                        let model = try JSONDecoder().decode([CountryCodeElement].self, from: response.data)
                        self?.delegate?.CountryCode(code: model)
                        self?.saveCountryCode(object: model, key: "countryCode")
                        self?.delegate?.hideProgressLoader()
                    } catch let jsonErr {
                        self?.delegate?.showError(error: jsonErr)
                        self?.delegate?.hideProgressLoader()
                    }
                // failure state
                case let .failure(error):
                    self?.delegate?.hideProgressLoader()
                    self?.delegate?.showError(error: error)
                }
            }
        }
    }

    // TODO: - get countery code from cache
    func GetCountryCode(key: String) -> [CountryCodeElement] {
        if let data = DataCache.instance.readData(forKey: key) {
            let decoder = JSONDecoder()
            return try! decoder.decode([CountryCodeElement].self, from: data)
        } else {
            return []
        }
    }

    // TODO: - save countery code to cache
    func saveCountryCode(object: [CountryCodeElement], key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            DataCache.instance.write(data: encoded, forKey: key)
        }
    }
}
