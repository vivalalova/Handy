//
//  File.swift
//
//
//  Created by Lova on 2024/5/5.
//

import SwiftSyntax
import SwiftSyntaxMacros

extension String {
    func lowercasedFirstLetter() -> String {
        return prefix(1).lowercased() + self.dropFirst()
    }
}

public struct AddDependencyKeyMacro: ExtensionMacro {
    public static func expansion(of node: AttributeSyntax, attachedTo declaration: some DeclGroupSyntax, providingExtensionsOf type: some TypeSyntaxProtocol, conformingTo protocols: [TypeSyntax], in context: some MacroExpansionContext) throws -> [ExtensionDeclSyntax] {
        guard let typeName = declaration.as(StructDeclSyntax.self)?.name.text ?? declaration.as(ClassDeclSyntax.self)?.name.text else {
            throw "use @AddDependencyKey in `struct` or `class`"
        }

        let ext: DeclSyntax = """
        extension DependencyValues {
            var \(raw: typeName.lowercasedFirstLetter()): \(raw: typeName) {
                get { self[\(raw: typeName).self] }
                set { self[\(raw: typeName).self] = newValue }
            }
        }
        """

        return [ext.cast(ExtensionDeclSyntax.self)]
    }
}
