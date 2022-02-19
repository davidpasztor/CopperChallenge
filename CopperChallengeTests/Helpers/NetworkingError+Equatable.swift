//
//  NetworkingError+Equatable.swift
//  CopperChallengeTests
//
//  Created by David Pasztor on 19/02/2022.
//

@testable import CopperChallenge

// Equatable conformance for easier testability
extension NetworkingError: Equatable {
    public static func == (lhs: NetworkingError, rhs: NetworkingError) -> Bool {
        switch (lhs, rhs) {
        case let (.decoding(lhsError), .decoding(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case let (.generic(lhsError), .generic(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.nonHTTPResponse, .nonHTTPResponse):
            return true
        case let (.unexpectedStatusCode(lhsCode), .unexpectedStatusCode(rhsCode)):
            return lhsCode == rhsCode
        case let (.url(lhsError), .url(rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}
