import SwiftSyntax
import SwiftSyntaxMacros

extension String: Error {}

public struct CodableMacro: ExtensionMacro {
    public static func expansion(of node: AttributeSyntax, attachedTo declaration: some DeclGroupSyntax, providingExtensionsOf type: some TypeSyntaxProtocol, conformingTo protocols: [TypeSyntax], in context: some MacroExpansionContext) throws -> [ExtensionDeclSyntax] {
        let inheritedTypes: InheritedTypeListSyntax? =
            if let declaration = declaration.as(StructDeclSyntax.self) {
                declaration.inheritanceClause?.inheritedTypes
            } else if let declaration = declaration.as(ClassDeclSyntax.self) {
                declaration.inheritanceClause?.inheritedTypes
            } else if let declaration = declaration.as(ExtensionDeclSyntax.self) {
                // needs to reflection
                declaration.inheritanceClause?.inheritedTypes
            } else {
                throw "use @Codable in `struct` or `class`"
            }

        if inheritedTypes?.contains(where: { inherited in inherited.type.trimmedDescription == "Codable" }) != true {
            let ext: DeclSyntax = """
            extension \(type.trimmed): Codable { }
            """

            return [ext.cast(ExtensionDeclSyntax.self)]
        }

        return []
    }
}

extension CodableMacro: MemberMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        let variables: [VariableDeclSyntax] = declaration.memberBlock.members
            .compactMap { $0.decl.as(VariableDeclSyntax.self) }

        let initialVariables = variables.compactMap {
            guard let name = $0.name, let type = $0.type else {
                return nil
            }

            if let initialValue = $0.initialValue {
                return "\(name): \(type) = \(initialValue)"
            } else {
                return "\(name): \(type) = nil"
            }
        }
        .joined(separator: ", ")

        let initialerA = try InitializerDeclSyntax("init(\(raw: initialVariables))") {
            for variable in variables {
                if let name = variable.name {
                    "self.\(raw: name) = \(raw: name)"
                }
            }
        }

        let initialerC = try InitializerDeclSyntax("init(from decoder: Decoder) throws") {
            """
            let container = try decoder.container(keyedBy: CodingKeys.self)

            """

            for variable in variables {
                if variable.isOptional == false && variable.hasDefaultValue == false {
                    throw "make variable optional, or set default value"
                }

                if let name = variable.name, let type = variable.type {
                    """
                    if let \(raw: name)Value = try? container.decode(\(raw: type).self, forKey: .\(raw: name)) {
                        self.\(raw: name) = \(raw: name)Value
                    }
                    """
                }
            }
        }

        return [
            DeclSyntax(initialerA),
            DeclSyntax(initialerC)
        ]
    }
}
