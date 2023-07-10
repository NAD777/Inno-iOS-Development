//
//  NetworkManger.swift
//  Ricked
//
//  Created by Антон Нехаев on 30.06.2023.
//

import Moya

protocol NetworkManagerProtocol {
    func fetchCharacters(
        completion: @escaping (Result<CharacterResponseWelcome, Error>
        ) -> Void)
}

final class NetworkManger: NetworkManagerProtocol {
    
//    private var provider: MoyaProvider<APITarget> = {
//        let session = Session(configuration: URLSessionConfiguration.default, startRequestsImmediately: false)
//        session.sessionConfiguration.requestCachePolicy = .reloadIgnoringCacheData
//        session.sessionConfiguration.urlCache = nil
//        let provider = MoyaProvider<APITarget>(session: session)
//
//        return provider
//    }()
    private var provider = MoyaProvider<APITarget>()
    
    func fetchCharacters(
        completion: @escaping (Result<CharacterResponseWelcome, Error>
        ) -> Void) {
        request(target: .getCharacters, completion: completion)
    }
}

private extension NetworkManger {
    
    func request<T:Decodable>(
        target: APITarget,
        completion: @escaping (Result<T, Error>
        ) -> Void) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
