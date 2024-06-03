//
//  File.swift
//
//
//  Created by Lova on 2024/4/10.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct TestMacroPlugin: CompilerPlugin {
    let providingMacros: [SwiftSyntaxMacros.Macro.Type] = [
        AddAsyncMacro.self,
        StringifyMacro.self,

        CodableMacro.self,
        AddDependencyKeyMacro.self,
        AddEnvironmentKeyMacro.self
    ]
}
