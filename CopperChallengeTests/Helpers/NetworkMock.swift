//
//  NetworkMock.swift
//  CopperChallengeTests
//
//  Created by David Pasztor on 19/02/2022.
//

import Foundation
import Combine
@testable import CopperChallenge

class NetworkMock: NetworkProtocol {
    /// `JSONDecoder` to use for decoding `requestResult` into `ResponseModel` when calling `decodableRequestPublisher`
    var jsonDecoder: JSONDecoder
    /**
     The result that calls to `decodableRequestPublisher` should produce. In case the publisher should fail, initialise this property to `failure` with the expected error.
     In case the publisher should succeed, initialise this property to `success` with the expected `Decodable` conformant type encoded to `Data`.
     */
    var requestResult: Result<Data, NetworkingError>

    init(requestResults: Result<Data, NetworkingError>, jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.requestResult = requestResults
        self.jsonDecoder = jsonDecoder
    }

    func decodableRequest<ResponseModel>(for url: URL, responseModelType: ResponseModel.Type) async throws -> ResponseModel where ResponseModel : Decodable {
        switch requestResult {
        case let .success(data):
            return try jsonDecoder.decode(ResponseModel.self, from: data)
        case let .failure(error):
            throw error
        }
    }
}
