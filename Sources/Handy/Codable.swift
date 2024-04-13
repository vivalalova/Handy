//
//  File.swift
//
//
//  Created by Lova on 2024/4/8.
//

import Foundation

public
extension Encodable {
    var encoder: JSONEncoder { JSONEncoder() }

    func toDict() -> [String: Any]? {
        guard let data = try? encoder.encode(self) else {
            return nil
        }

        return data.toCollection()
    }

    func toJSONString(pretty: Bool = false) -> String? {
        guard let data = try? self.encoder.encode(self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }
}

public
extension Decodable {
    private static var decoder: JSONDecoder { JSONDecoder() }

    static func array(from string: String?) -> [Self] {
        guard let data = string?.data(using: .utf8) else {
            return []
        }

        return self.array(from: data)
    }

    static func array(from data: Data) -> [Self] {
        do {
            return try JSONDecoder().decode([Self].self, from: data)
        } catch let DecodingError.keyNotFound(key, context) {
            print("keyNotFound", key, context)
        } catch let DecodingError.typeMismatch(type, context) {
            print("typeMismatch", type, context)
        } catch let DecodingError.valueNotFound(value, context) {
            print("valueNotFound", value, context)
        } catch let DecodingError.dataCorrupted(context) {
            print("dataCorrupted", context)
        } catch {
            print(error)
        }

        return []
    }

    static func model(from string: String?) -> Self? {
        guard let data = string?.data(using: .utf8) else {
            return nil
        }

        return self.model(from: data)
    }

    static func model(from data: Data) -> Self? {
        do {
            return try self.decoder.decode(self, from: data)
        } catch let DecodingError.keyNotFound(key, context) {
            print("keyNotFound", key, context)
        } catch let DecodingError.typeMismatch(type, context) {
            print("typeMismatch", type, context)
        } catch let DecodingError.valueNotFound(value, context) {
            print("valueNotFound", value, context)
        } catch let DecodingError.dataCorrupted(context) {
            print("dataCorrupted", context)
        } catch {
            print(error)
        }

        return nil
    }
}
