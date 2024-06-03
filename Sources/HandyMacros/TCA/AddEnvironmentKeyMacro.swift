//
//  File.swift
//
//
//  Created by Lova on 2024/5/5.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct AddEnvironmentKeyMacro: ExtensionMacro {
    public static func expansion(of node: AttributeSyntax, attachedTo declaration: some DeclGroupSyntax, providingExtensionsOf type: some TypeSyntaxProtocol, conformingTo protocols: [TypeSyntax], in context: some MacroExpansionContext) throws -> [ExtensionDeclSyntax] {
        guard let typeName = declaration.as(StructDeclSyntax.self)?.name.text ?? declaration.as(ClassDeclSyntax.self)?.name.text else {
            throw "use @AddDependencyKey in `struct` or `class`"
        }

        let ext: DeclSyntax = """
        extension EnvironmentValues {
            var \(raw: typeName.lowercasedFirstLetter()): \(raw: typeName) {
                get { self[\(raw: typeName).self] }
                set { self[\(raw: typeName).self] = newValue }
            }
        }

        extension View {
            func \(raw: typeName.lowercasedFirstLetter())(_ \(raw: typeName.lowercasedFirstLetter()): \(raw: typeName)) -> some View {
                environment(\\.\(raw: typeName.lowercasedFirstLetter()), \(raw: typeName.lowercasedFirstLetter()))
            }
        }
        """

        return [ext.cast(ExtensionDeclSyntax.self)]
    }
}
