import Handy
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class TestMacro: XCTestCase {
    @Codable
    struct Model {
        var id: Int?
        var name = ""
    }

    func testExample() throws {
        var model: Model? = Model(id: 1, name: "hihi")

        let string = model.toJSONString()

        XCTAssertEqual(
            string,
            """
            {"id":1,"name":"hihi"}
            """
        )

        model = Model.model(from: string)

        XCTAssertEqual(model?.id, 1)
        XCTAssertEqual(model?.name, "hihi")
    }

    func testTwice() throws {
        return

        let string = """
        {
            "id":1
        }
        """

        let model = Model.model(from: string)

        XCTAssertEqual(model?.id, 1)
        XCTAssertEqual(model?.name, "")
    }

    func testOO() throws {
        #if canImport(HandyMacros)
        assertMacroExpansion(
            """
            #stringify(a + b)
            """,
            expandedSource: """
            (a + b, "a + b")
            """,
            macros: testMacros
        )
        #else
        print("????")
        #endif
    }
}
