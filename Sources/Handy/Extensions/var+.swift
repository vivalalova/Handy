//
//  File.swift
//
//
//  Created by Lova on 2024/4/11.
//

import Foundation

public
extension Collection {
    func data() -> Data? {
        try? JSONSerialization.data(withJSONObject: self)
    }

    func toJSONString() -> String? {
        self.data()?.string
    }
}

public
extension Data {
    var string: String? {
        String(data: self, encoding: .utf8)
    }

    func toCollection<T: Collection>() -> T? {
        let a = try? JSONSerialization.jsonObject(with: self, options: .fragmentsAllowed)
        return a as? T
    }

    func toArray<T: Collection>() -> [T] {
        self.toCollection() ?? []
    }
}

public
extension String {
    func decode<T: Decodable>() -> T? {
        guard let jsonData = self.data(using: .utf8) else {
            return nil
        }

        return try? JSONDecoder().decode(T.self, from: jsonData)
    }
}
