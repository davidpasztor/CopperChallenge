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

    func decodableRequestPublisher<ResponseModel: Decodable>(for url: URL, responseModelType: ResponseModel.Type) -> AnyPublisher<ResponseModel, NetworkingError> {
        switch requestResult {
        case let .success(data):
            do {
                let decodedModel = try jsonDecoder.decode(ResponseModel.self, from: data)
                return Just(decodedModel).setFailureType(to: NetworkingError.self).eraseToAnyPublisher()
            } catch {
                return Fail(error: .generic(error)).eraseToAnyPublisher()
            }
        case let .failure(error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}
