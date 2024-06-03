//
//  TestAddEnvironmentValues.swift
//
//
//  Created by Lova on 2024/6/3.
//

import Dependencies
import Handy
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class TestAddEnvironmentValues: XCTestCase {
    func testExample() throws {
        assertMacroExpansion(
            """
            @AddEnvironmentKey
            private struct Foo {
                static let defaultValue = 1
            }

            """,
            expandedSource: """
            private struct Foo {
                static let defaultValue = 1
            }

            extension EnvironmentValues {
                var foo: Foo {
                    get {
                        self [Foo.self]
                    }
                    set {
                        self [Foo.self] = newValue
                    }
                }
            }

            extension View {
                func foo(_ foo: Foo) -> some View {
                    environment(\\.foo, foo)
                }
            }
            """,
            macros: testMacros
        )
    }
}
