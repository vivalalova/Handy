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
        guard let typeName = declaration.as(StructDeclSyntax.self)?.name.text ?? declaration.as(EnumDeclSyntax.self)?.name.text else {
            throw "use @AddDependencyKey in `struct` or `enum`"
        }

        guard let defaultValueType = declaration.memberBlock.members.first?.as(MemberBlockItemSyntax.self)?.decl.as(VariableDeclSyntax.self)?.bindings.first?.as(PatternBindingSyntax.self)?.typeAnnotation?.as(TypeAnnotationSyntax.self)?.type.as(IdentifierTypeSyntax.self)?.name.text else {
            throw "type of defaultValue not defined"
        }

        let ext: DeclSyntax = """
        extension \(raw: typeName): EnvironmentKey {}

        extension EnvironmentValues {
            var \(raw: typeName.lowercasedFirstLetter()): \(raw: defaultValueType) {
                get { self[\(raw: typeName).self] }
                set { self[\(raw: typeName).self] = newValue }
            }
        }

        extension View {
            func \(raw: typeName.lowercasedFirstLetter())(_ value: \(raw: defaultValueType)) -> some View {
                environment(\\.\(raw: typeName.lowercasedFirstLetter()), value)
            }
        }
        """

        return [ext.cast(ExtensionDeclSyntax.self)]
    }
}
