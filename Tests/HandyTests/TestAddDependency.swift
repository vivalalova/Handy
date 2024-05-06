//
//  TestDependency.swift
//
//
//  Created by Lova on 2024/5/5.
//

import Dependencies
import Handy
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class TestDependency: XCTestCase {
    func testExample() throws {
        assertMacroExpansion(
            """
            @AddDependencyKey
            struct NumberFactClient {
                var trivia: (Int) async throws -> String

                var date: (Int) async throws -> String
            }
            """,
            expandedSource: """
            struct NumberFactClient {
                var trivia: (Int) async throws -> String

                var date: (Int) async throws -> String
            }

            extension DependencyValues {
                var numberFactClient: NumberFactClient {
                    get {
                        self [NumberFactClient.self]
                    }
                    set {
                        self [NumberFactClient.self] = newValue
                    }
                }
            }
            """,
            macros: testMacros
        )
    }
}
