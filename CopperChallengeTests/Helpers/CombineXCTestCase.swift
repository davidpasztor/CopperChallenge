//
//  CombineXCTestCase.swift
//  CopperChallengeTests
//
//  Created by David Pasztor on 21/02/2022.
//

import XCTest
import Combine

/// `XCTestCase` subclass suitable for testing code using `Combine`. Adds a `subscriptions` property for storing subscriptions from tests, which is emptied after each test case.
class CombineXCTestCase: XCTestCase {
    var subscriptions = Set<AnyCancellable>()

    override func tearDown() {
        super.tearDown()

        subscriptions.removeAll()
    }
}
