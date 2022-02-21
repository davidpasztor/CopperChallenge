//
//  DecodingError+Equatable.swift
//  CopperChallengeTests
//
//  Created by David Pasztor on 21/02/2022.
//

import Foundation

extension DecodingError: Equatable {
    public static func == (lhs: DecodingError, rhs: DecodingError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}
