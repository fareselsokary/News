//
//  newsServices.swift
//  News
//
//  Created by fareselsokary on 8/15/19.
//  Copyright © 2019 Fares. All rights reserved.
//

import Foundation
import Moya

enum newsServices {
    case getTopHeadlines(countryCode: String, pageNum: Int, pageSize: Int)
    case countryCode
}

extension newsServices: TargetType {
    var baseURL: URL {
        switch self {
        case .getTopHeadlines:
            var url = URLComponents(string: Routes.baseUrl)!
            let apiKey = URLQueryItem(name: "apiKey", value: Routes.ApiKey)
            url.queryItems = [apiKey]
            return url.url!
        case .countryCode:
            return URL(string: Routes.countryCodeUrl)!
        }
    }

    var path: String {
        switch self {
        case .getTopHeadlines(_, _, _), .countryCode:
            return ""
        }
    }

    var method: Moya.Method {
        switch self {
        case .getTopHeadlines, .countryCode:
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case let .getTopHeadlines(countryCode, pageNum, pageSize):
            let parameters = [
                "country": countryCode,
                "pagesize": pageSize,
                "page": pageNum,
            ] as [String: Any]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .countryCode:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
