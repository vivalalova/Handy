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

extension CodableMacro: MemberMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        let members = declaration.memberBlock.members
        members.map { member in
            print(member)
        }

        return []
//
//        let propertyContainer = try ModelMemberPropertyContainer(decl: declaration, context: context)
//        let decoder = try propertyContainer.genDecoderInitializer(config: .init(isOverride: false))
//        let encoder = try propertyContainer.genEncodeFunction(config: .init(isOverride: false))
//        let memberwiseInit = try propertyContainer.genMemberwiseInit(config: .init(isOverride: false))
//        return [decoder, encoder, memberwiseInit]
    }
}
