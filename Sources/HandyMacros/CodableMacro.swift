import SwiftSyntax
import SwiftSyntaxMacros

public struct CodableMacro: ExtensionMacro {
    struct Err: Error, CustomStringConvertible {
        var message: String

        init(_ message: String) {
            self.message = message
        }

        var description: String {
            self.message
        }
    }

    public static func expansion(of node: AttributeSyntax, attachedTo declaration: some DeclGroupSyntax, providingExtensionsOf type: some TypeSyntaxProtocol, conformingTo protocols: [TypeSyntax], in context: some MacroExpansionContext) throws -> [ExtensionDeclSyntax] {
        let inheritedTypes: InheritedTypeListSyntax? =
            if let declaration = declaration.as(StructDeclSyntax.self) {
                declaration.inheritanceClause?.inheritedTypes
            } else if let declaration = declaration.as(ClassDeclSyntax.self) {
                declaration.inheritanceClause?.inheritedTypes
            } else {
                throw Err("use @Codable in `struct` or `class`")
            }

        guard inheritedTypes?.contains(where: { inherited in inherited.type.trimmedDescription == "Codable" }) != true else {
            return []
        }

        let ext: DeclSyntax = """
        extension \(type.trimmed): Codable {

        }
        """

        return [ext.cast(ExtensionDeclSyntax.self)]
    }
}

extension VariableDeclSyntax {
    var variableNames: [String] {
        bindings
            .compactMap {
                $0.pattern.as(IdentifierPatternSyntax.self)?.identifier.text
            }
    }

    var typeName: String? {
        if let type = self.bindings.compactMap(\.typeAnnotation).first?.type.description {
            return type
        }

        func expect<S: ExprSyntaxProtocol>(_ syntaxType: S.Type) -> Bool {
            self.bindings.compactMap(\.initializer).first?.value.is(syntaxType) == true
        }

        if expect(StringLiteralExprSyntax.self) {
            return "String"
        } else if expect(IntegerLiteralExprSyntax.self) {
            return "Int"
        } else if expect(FloatLiteralExprSyntax.self) {
            return "Double"
        } else if expect(BooleanLiteralExprSyntax.self) {
            return "Bool"
        }

        return nil
    }

    var isOptional: Bool {
        if bindings.compactMap(\.typeAnnotation).first?.type.is(OptionalTypeSyntax.self) == true {
            true
        } else if bindings.compactMap(\.initializer).first?.value.as(DeclReferenceExprSyntax.self)?.description.hasPrefix("Optional<") == true {
            true
        } else if bindings.compactMap(\.initializer).first?.value.as(DeclReferenceExprSyntax.self)?.description.hasPrefix("Optional(") == true {
            true
        } else {
            false
        }
    }
}

extension CodableMacro: MemberMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        let members = declaration.memberBlock.members
        let cases = members.compactMap { $0.decl.as(EnumDeclSyntax.self) }

        let variables = declaration.memberBlock.members
            .compactMap {
                let variableNames = $0.decl.as(VariableDeclSyntax.self)?.variableNames
                let isOptional = $0.decl.as(VariableDeclSyntax.self)?.isOptional
                let typeName = $0.decl.as(VariableDeclSyntax.self)?.typeName

                return $0.decl
                    .as(VariableDeclSyntax.self)?
                    .bindings
                    .compactMap { oo -> DeclSyntax? in
                        let variableName = oo.pattern.as(IdentifierPatternSyntax.self)?.identifier.text

                        guard let variableName, let typeName, let isOptional else {
                            return nil
                        }

                        let defaultValue = oo.initializer?.as(InitializerClauseSyntax.self)?.value.as(StringLiteralExprSyntax.self)?.segments.first?.as(StringSegmentSyntax.self)?.content.text ?? ""

                        if isOptional {
                            return """
                            var _\(raw: variableName): \(raw: typeName)
                            """
                        } else {
                            return """
                            var _\(raw: variableName): \(raw: typeName) = "\(raw: defaultValue)"
                            """
                        }
                    }
            }
            .flatMap { $0 }

        return variables
    }
}
