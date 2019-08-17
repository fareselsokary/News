//
//  topHeadlinespresenter.swift
//  News
//
//  Created by fareselsokary on 8/15/19.
//  Copyright © 2019 Fares. All rights reserved.
//

import Foundation
import Moya

// MARK: - top Headlines presenter Delegate

protocol topHeadlinespresenterDelegate: class {
    func Headlines(headlines: [Article], count: Int)
    func hideProgressLoader()
    func showError(error: String)
}

class topHeadlinespresenter {
    weak var delegate: topHeadlinespresenterDelegate?
    private let newsProvider = MoyaProvider<newsServices>()
    // TODO: - get head line from api
    func getTopHeadlines(countryCode: String, pageNum: Int? = 1) {
        newsProvider.request(.getTopHeadlines(countryCode: countryCode, pageNum: pageNum!, pageSize: 10)) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                // success state
                case let .success(response):
                    do {
                        self?.delegate?.hideProgressLoader()
                        let model = try JSONDecoder().decode(TopHeadlines.self, from: response.data)
                        self?.delegate?.Headlines(headlines: model.articles ?? [],
                                                  count: model.totalResults ?? 0)
                    } catch let jsonErr {
                        self?.delegate?.showError(error: jsonErr.localizedDescription)
                        self?.delegate?.hideProgressLoader()
                    }
                // failure state
                case let .failure(error):

                    self?.delegate?.hideProgressLoader()
                    self?.delegate?.showError(error: error.localizedDescription)
                }
            }
        }
    }

    // TODO: - get countery code from cache
    func GetCacheHeadlines(key: String) -> [Article] {
        if let data = DataCache.instance.readData(forKey: key) {
            let decoder = JSONDecoder()
            return try! decoder.decode([Article].self, from: data)
        } else {
            return []
        }
    }

    // TODO: - save countery code to cache
    func saveCacheHeadlines(object: [Article], key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            DataCache.instance.write(data: encoded, forKey: key)
        }
    }
}
