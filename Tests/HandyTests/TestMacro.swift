import Handy
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

struct Model0: Codable {
    var name = ""
}

final class TestMacro: XCTestCase {
    func testOOOO() throws {
        assertMacroExpansion(
            """
            @Codable
            struct Model {
                var int = 1
                var intOptional: Int?
                var double: Double = 1
                var doubleOptional: Double?

                var string = ""
                var stringOptional: String?

                var arrayInt: [Int] = [1,2]
                var arrayIntOptional: [Int]?

                var subModel: SubModel?

                @Codable
                struct SubModel {
                    var none = ""
                }
            }
            """,
            expandedSource: """
            struct Model {
                var int = 1
                var intOptional: Int?
                var double: Double = 1
                var doubleOptional: Double?

                var string = ""
                var stringOptional: String?

                var arrayInt: [Int] = [1,2]
                var arrayIntOptional: [Int]?

                var subModel: SubModel?
                struct SubModel {
                    var none = ""

                    init(none: String = "") {
                        self.none = none
                    }

                    init(from decoder: Decoder) throws {
                        let container = try decoder.container(keyedBy: CodingKeys.self)
                        if let noneValue = try? container.decode(String.self, forKey: .none) {
                            self.none = noneValue
                        }
                    }
                }

                init(int: Int = 1, intOptional: Int? = nil, double: Double  = 1, doubleOptional: Double? = nil, string: String = "", stringOptional: String? = nil, arrayInt: [Int]  = [1, 2], arrayIntOptional: [Int]? = nil, subModel: SubModel? = nil) {
                    self.int = int
                    self.intOptional = intOptional
                    self.double = double
                    self.doubleOptional = doubleOptional
                    self.string = string
                    self.stringOptional = stringOptional
                    self.arrayInt = arrayInt
                    self.arrayIntOptional = arrayIntOptional
                    self.subModel = subModel
                }

                init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    if let intValue = try? container.decode(Int.self, forKey: .int) {
                        self.int = intValue
                    }
                    if let intOptionalValue = try? container.decode(Int?.self, forKey: .intOptional) {
                        self.intOptional = intOptionalValue
                    }
                    if let doubleValue = try? container.decode(Double .self, forKey: .double) {
                        self.double = doubleValue
                    }
                    if let doubleOptionalValue = try? container.decode(Double?.self, forKey: .doubleOptional) {
                        self.doubleOptional = doubleOptionalValue
                    }
                    if let stringValue = try? container.decode(String.self, forKey: .string) {
                        self.string = stringValue
                    }
                    if let stringOptionalValue = try? container.decode(String?.self, forKey: .stringOptional) {
                        self.stringOptional = stringOptionalValue
                    }
                    if let arrayIntValue = try? container.decode([Int] .self, forKey: .arrayInt) {
                        self.arrayInt = arrayIntValue
                    }
                    if let arrayIntOptionalValue = try? container.decode([Int]?.self, forKey: .arrayIntOptional) {
                        self.arrayIntOptional = arrayIntOptionalValue
                    }
                    if let subModelValue = try? container.decode(SubModel?.self, forKey: .subModel) {
                        self.subModel = subModelValue
                    }
                }
            }

            extension SubModel: Codable {
            }

            extension Model: Codable {
            }
            """,
            macros: testMacros
        )
    }

    func testSimple() throws {
        assertMacroExpansion(
            """
            @Codable
            struct Model {
                var int = 1
                var intOptional: Int?
                var double: Double = 1
                var doubleOptional: Double?

                var string = ""
                var stringOptional: String?

                var arrayInt: [Int] = [1,2]
                var arrayIntOptional: [Int]?
            }
            """,
            expandedSource: """
            struct Model {
                var int = 1
                var intOptional: Int?
                var double: Double = 1
                var doubleOptional: Double?

                var string = ""
                var stringOptional: String?

                var arrayInt: [Int] = [1,2]
                var arrayIntOptional: [Int]?

                init(int: Int = 1, intOptional: Int? = nil, double: Double  = 1, doubleOptional: Double? = nil, string: String = "", stringOptional: String? = nil, arrayInt: [Int]  = [1, 2], arrayIntOptional: [Int]? = nil) {
                    self.int = int
                    self.intOptional = intOptional
                    self.double = double
                    self.doubleOptional = doubleOptional
                    self.string = string
                    self.stringOptional = stringOptional
                    self.arrayInt = arrayInt
                    self.arrayIntOptional = arrayIntOptional
                }

                init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    if let intValue = try? container.decode(Int.self, forKey: .int) {
                        self.int = intValue
                    }
                    if let intOptionalValue = try? container.decode(Int?.self, forKey: .intOptional) {
                        self.intOptional = intOptionalValue
                    }
                    if let doubleValue = try? container.decode(Double .self, forKey: .double) {
                        self.double = doubleValue
                    }
                    if let doubleOptionalValue = try? container.decode(Double?.self, forKey: .doubleOptional) {
                        self.doubleOptional = doubleOptionalValue
                    }
                    if let stringValue = try? container.decode(String.self, forKey: .string) {
                        self.string = stringValue
                    }
                    if let stringOptionalValue = try? container.decode(String?.self, forKey: .stringOptional) {
                        self.stringOptional = stringOptionalValue
                    }
                    if let arrayIntValue = try? container.decode([Int] .self, forKey: .arrayInt) {
                        self.arrayInt = arrayIntValue
                    }
                    if let arrayIntOptionalValue = try? container.decode([Int]?.self, forKey: .arrayIntOptional) {
                        self.arrayIntOptional = arrayIntOptionalValue
                    }
                }
            }

            extension Model: Codable {
            }
            """,
            macros: testMacros
        )
    }
}
