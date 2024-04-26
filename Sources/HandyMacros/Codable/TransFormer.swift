//
//  File.swift
//
//
//  Created by Lova on 2024/4/23.
//

import Foundation

public
protocol Transformer {
    associatedtype Object
    associatedtype Value

    func fromJSON(_ value: Any?) -> Object?

    func toJSON(_ value: Object?) -> Value?
}

struct UnixTimestampTransformer: Transformer {
    public typealias Value = Double
    public typealias Object = Date

    func fromJSON(_ value: Any?) -> Object? {
        if let value = value as? Double {
            return Date(timeIntervalSince1970: value)
        }

        if let string = value as? String, let value = Double(string) {
            return Date(timeIntervalSince1970: Double(value))
        }

        return nil
    }

    func toJSON(_ value: Object?) -> Value? {
        value?.timeIntervalSince1970
    }
}
