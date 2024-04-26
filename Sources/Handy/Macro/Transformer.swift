// MARK: - Transformer

import Foundation

public
protocol Transformer {
    associatedtype Object
    associatedtype Value

    func fromJSON(_ value: Any?) -> Object?

    func toJSON(_ value: Object?) -> Value?
}

public
struct UnixTimestampTransformer: Transformer {
    public typealias Value = Double
    public typealias Object = Date

    public func fromJSON(_ value: Any?) -> Object? {
        if let value = value as? Double {
            return Date(timeIntervalSince1970: value)
        } else if let string = value as? String, let value = Double(string) {
            return Date(timeIntervalSince1970: value)
        }

        return nil
    }

    public func toJSON(_ value: Object?) -> Value? {
        value?.timeIntervalSince1970
    }
}
