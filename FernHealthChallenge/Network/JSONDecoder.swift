//
//  JSONEncoder.swift
//  FernHealthChallenge
//
//  Created by Arturo Reyes on 6/23/20.
//  Copyright © 2020 Arturo Reyes. All rights reserved.
//
import Foundation

/// Protocol to decode data
public protocol DataDecoder {
    static func decode(_ data: Data) -> AnyObject?
}

/// To decode JSON data
public struct JSONDataDecoder: DataDecoder {
    public static func decode(_ data: Data) -> AnyObject? {
        var parsedResult: AnyObject? = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            print(error.localizedDescription)
        }
        return parsedResult
    }
}

