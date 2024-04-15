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
                var number: Int?
                var name = ""

                var array: [Int] = []
                var subModel: SubModel?

                @Codable
                struct SubModel {
                    var none = ""
                }
            }
            """,
            expandedSource: """
            struct Model {
                var number: Int?
                var name = ""

                var array: [Int] = []
                var subModel: SubModel?
                struct SubModel {
                    var none = ""

                    init(from decoder: Decoder) throws {
                        let container = try decoder.container(keyedBy: CodingKeys.self)
                        if let noneValue = try? container.decode(String.self, forKey: .none) {
                            self.none = noneValue
                        }
                    }
                }

                init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    if let numberValue = try? container.decode(Int?.self, forKey: .number) {
                        self.number = numberValue
                    }
                    if let nameValue = try? container.decode(String.self, forKey: .name) {
                        self.name = nameValue
                    }
                    if let arrayValue = try? container.decode([Int] .self, forKey: .array) {
                        self.array = arrayValue
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
}

// extension TestMacro {
//@Codable
//struct Model {
//    var number: Int?
//    var name = ""
//
//    var array: [Int] = []
//    var yyy: [String] = []
//    var subModel: SubModel?
//
//    struct SubModel: Codable {
//        var none = ""
//    }
//}
//    func testExample() throws {
//        var model: Model? = Model(number: 1, name: "hihi")
//
//        let string = model.toJSONString()
//
//        XCTAssertEqual(
//            string,
//            """
//            {"number":1,"name":"hihi"}
//            """
//        )
//
//        model = Model.model(from: string)
//
//        XCTAssertEqual(model?.number, 1)
//        XCTAssertEqual(model?.name, "hihi")
//    }
//
//    func testTwice() throws {
//        return
//
//        let string = """
//        {
//            "number":1
//        }
//        """
//
//        let model = Model.model(from: string)
//
//        XCTAssertEqual(model?.number, 1)
//        XCTAssertEqual(model?.name, "")
//    }
// }
