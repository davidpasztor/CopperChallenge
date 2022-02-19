//
//  Network.swift
//  CopperChallenge
//
//  Created by David Pasztor on 19/02/2022.
//

import Foundation
import Combine

protocol NetworkProtocol {
    /**
     `Publisher` decoding the JSON response from the specified `URL`.
        - parameters:
            - url: `URL` to make the request to
            - responseModelType: `Decodable` conformant type to use for decoding the JSON response
     */
    func decodableRequestPublisher<ResponseModel: Decodable>(for url: URL, responseModelType: ResponseModel.Type) -> AnyPublisher<ResponseModel, NetworkingError>
}

final class Network: NetworkProtocol {
    private let jsonDecoder: JSONDecoder
    private let urlSession: URLSession

    init(jsonDecoder: JSONDecoder = JSONDecoder(), urlSession: URLSession = .shared) {
        self.jsonDecoder = jsonDecoder
        self.urlSession = urlSession
    }

    func decodableRequestPublisher<ResponseModel: Decodable>(for url: URL, responseModelType: ResponseModel.Type) -> AnyPublisher<ResponseModel, NetworkingError> {
        // Create local variable to avoid having to access self inside the tryMap closure
        let jsonDecoder = self.jsonDecoder
        return urlSession.dataTaskPublisher(for: url)
            .tryMap { data, response -> ResponseModel in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkingError.nonHTTPResponse
                }

                switch httpResponse.statusCode {
                case 200..<300:
                    return try jsonDecoder.decode(responseModelType, from: data)
                default:
                    throw NetworkingError.unexpectedStatusCode(httpResponse.statusCode)
                }
            }
            .mapError { error -> NetworkingError in
                switch error {
                case let decodingError as DecodingError:
                    return .decoding(decodingError)
                case let networkingError as NetworkingError:
                    return networkingError
                case let urlError as URLError:
                    return .url(urlError)
                default:
                    return .generic(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
