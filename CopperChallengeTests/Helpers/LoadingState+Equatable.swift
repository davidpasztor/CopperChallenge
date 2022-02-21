//
//  LoadingState+Equatable.swift
//  CopperChallengeTests
//
//  Created by David Pasztor on 21/02/2022.
//

@testable import CopperChallenge

extension LoadingState: Equatable {
    public static func == (lhs: LoadingState, rhs: LoadingState) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial):
            return true
        case (.loading, .loading):
            return true
        case (.loaded, .loaded):
            return true
        case let (.error(lhsError), .error(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
