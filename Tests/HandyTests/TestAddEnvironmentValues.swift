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
            struct Foo {
                static let defaultValue: Double = 1
            }

            """,
            expandedSource: """
            struct Foo {
                static let defaultValue: Double = 1
            }

            extension Foo: EnvironmentKey {
            }

            extension EnvironmentValues {
                var foo: Double {
                    get { self[Foo.self] }
                    set { self[Foo.self] = newValue }
                }
            }

            extension View {
                func foo(_ value: Double) -> some View {
                    environment(\\.foo, value)
                }
            }

            """,
            macros: testMacros
        )
    }
}
