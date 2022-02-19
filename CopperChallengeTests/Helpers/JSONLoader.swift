//
//  JSONLoader.swift
//  CopperChallengeTests
//
//  Created by David Pasztor on 19/02/2022.
//

import Foundation

import Foundation

enum JSONLoaderError: Error {
    case fileNotFound(fileName: String)
}

/// Test helper class which loads and parses JSONs from the test Bundle
final class JSONLoader {
    static func loadJSONData(fileName: String) throws -> Data {
        let testBundle = Bundle(for: JSONLoader.self)
        guard let path = testBundle.path(forResource: fileName, ofType: "json") else {
            throw JSONLoaderError.fileNotFound(fileName: fileName)
        }
        return try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    }

    static func parseJSON<T: Decodable>(fileName: String, type: T.Type, jsonDecoder: JSONDecoder = JSONDecoder()) throws -> T {
        let jsonData = try loadJSONData(fileName: fileName)
        let object = try jsonDecoder.decode(type, from: jsonData)
        return object
    }
}

