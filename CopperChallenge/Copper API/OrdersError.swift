//
//  OrdersError.swift
//  CopperChallenge
//
//  Created by David Pasztor on 19/02/2022.
//

import Foundation

enum OrdersError: LocalizedError {
    case cannotCreateURL(forEndpoint: CopperEndpoint)
    case dataPersistenceError
    case generic(Error)
    case networking(NetworkingError)

    var failureReason: String? {
        let tryAgainLater = "Please try again later"

        switch self {
        case let .cannotCreateURL(forEndpoint: endpoint):
            let endpointName: String
            switch endpoint {
            case .orders:
                endpointName = "orders"
            }

            return "We ran into an issue while retrieving \(endpointName). \(tryAgainLater)"
        case .dataPersistenceError:
            return "We weren't able to cache your orders. You can still use the app, but will need internet connection to load the data once the app is closed."
        case let .generic(error):
            return "We ran into an unexpected issue \(error.localizedDescription). \(tryAgainLater)"
        case let .networking(networkingError):
            return networkingError.failureReason
        }
    }
}
