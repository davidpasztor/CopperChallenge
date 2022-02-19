//
//  OrdersError+Equatable.swift
//  CopperChallengeTests
//
//  Created by David Pasztor on 19/02/2022.
//

@testable import CopperChallenge

// Equatable conformance for easier testability
extension OrdersError: Equatable {
    public static func == (lhs: OrdersError, rhs: OrdersError) -> Bool {
        switch (lhs, rhs) {
        case let (.cannotCreateURL(forEndpoint: lhsEndpoint), .cannotCreateURL(forEndpoint: rhsEndpoint)):
            return lhsEndpoint == rhsEndpoint
        case let (.generic(lhsError), .generic(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case let (.networking(lhsError), .networking(rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}
