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
     Decode the JSON response from the specified `URL`
     - parameters:
     - url: `URL` to make the request to
     - responseModelType: `Decodable` conformant type to use for decoding the JSON response
     */
    func decodableRequest<ResponseModel: Decodable>(for url: URL, responseModelType: ResponseModel.Type) async throws -> ResponseModel
}

final class Network: NetworkProtocol {
    private let jsonDecoder: JSONDecoder
    private let urlSession: URLSession

    init(jsonDecoder: JSONDecoder = JSONDecoder(), urlSession: URLSession = .shared) {
        self.jsonDecoder = jsonDecoder
        self.urlSession = urlSession
    }

    func decodableRequest<ResponseModel: Decodable>(for url: URL, responseModelType: ResponseModel.Type) async throws -> ResponseModel {
        let (data, response) = try await urlSession.data(from: url)
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
}
