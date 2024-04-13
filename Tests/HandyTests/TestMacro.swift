import Handy
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class TestMacro: XCTestCase {
    @Codable
    struct Model {
        var number: Int?
        var name = ""
    }

    func testExample() throws {
        var model: Model? = Model(number: 1, name: "hihi")

        let string = model.toJSONString()

        XCTAssertEqual(
            string,
            """
            {"number":1,"name":"hihi"}
            """
        )

        model = Model.model(from: string)

        XCTAssertEqual(model?.number, 1)
        XCTAssertEqual(model?.name, "hihi")
    }

    func testTwice() throws {
        return

        let string = """
        {
            "number":1
        }
        """

        let model = Model.model(from: string)

        XCTAssertEqual(model?.number, 1)
        XCTAssertEqual(model?.name, "")
    }
    
    func testOOOO() throws {
        assertMacroExpansion(
            """
            @Codable
            struct Model {
                var number: Int?
                var name = ""
            }
            """,
            expandedSource: """
            struct Model {
                var number: Int?
                var name = ""
            }

            extension Model: Codable {

            }
            """,
            macros: testMacros
        )
    }

    func testOO() throws {
        assertMacroExpansion(
            """
            #stringify(a + b)
            """,
            expandedSource: """
            (a + b, "a + b")
            """,
            macros: testMacros
        )
    }
}
