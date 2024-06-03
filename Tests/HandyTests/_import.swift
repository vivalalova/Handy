//
//  File.swift
//
//
//  Created by Lova on 2024/4/13.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(HandyMacros)
import HandyMacros
#endif

let testMacros: [String: Macro.Type] = [
    "stringify": StringifyMacro.self,
    "Codable": CodableMacro.self,
    "AddDependencyKey": AddDependencyKeyMacro.self,
    "AddEnvironmentKey": AddEnvironmentKeyMacro.self
]
