//
//  APITarget.swift
//  Ricked
//
//  Created by Антон Нехаев on 30.06.2023.
//

import Moya

enum APITarget {
    case getCharacters
}

extension APITarget: TargetType {

    var baseURL: URL {
        guard let url = URL(string: "https://rickandmortyapi.com") else {
            fatalError("Can not get the URL")
        }
        return url
    }

    var path: String {
        switch self {
        case .getCharacters:
            return "/api/character"
        }
    }

    var method: Moya.Method {
        .get
    }

    var task: Moya.Task {
//        .requestParameters(parameters: [
//            "vs_currency": "usd",
//            "order": "market_cap_desc",
//            "per_page": 250,
//            "page": 1,
//            "sparkline": true,
//            "price_change_percentage": "24h",
//            "locale": "en"
//        ], encoding: URLEncoding.default)
        .requestPlain
    }

    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
