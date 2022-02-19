//
//  CopperEndpoint.swift
//  CopperChallenge
//
//  Created by David Pasztor on 19/02/2022.
//

import Foundation

enum CopperEndpoint {
    case orders

    var url: URL {
        get throws {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "assessments.stage.copper.co"
            switch self {
            case .orders:
                components.path = "/ios/orders"
            }

            guard let url = components.url else {
                throw OrdersError.cannotCreateURL(forEndpoint: self)
            }

            return url
        }
    }
}
