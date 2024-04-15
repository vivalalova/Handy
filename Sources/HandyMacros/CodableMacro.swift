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
        extension \(type.trimmed): Codable { }
        """

        return [ext.cast(ExtensionDeclSyntax.self)]
    }
}

struct Variable {
    var name: String
    var isOptional: Bool
    var type: String
}

extension CodableMacro: MemberMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        let variables = declaration.memberBlock.members
            .compactMap { member -> Variable? in
                let variableName = member.decl.as(VariableDeclSyntax.self)?.variableName
                let isOptional = member.decl.as(VariableDeclSyntax.self)?.isOptional
                let typeName = member.decl.as(VariableDeclSyntax.self)?.typeName

                let yy = member.decl.as(VariableDeclSyntax.self)?.bindings//.compactMap(\.typeAnnotation).first?.type
                print("ii", yy)

                if variableName == "array" {
                    let type = member.decl
                        .as(VariableDeclSyntax.self)?
                        .bindings
                        .first?
                        .as(PatternBindingSyntax.self)?
                        .typeAnnotation?
                        .as(TypeAnnotationSyntax.self)?
                        .type

//                        .as(PatternBindingListSyntax.self)?
//                        .first?
//                        .as(PatternBindingSyntax.self)
//                        .initializer?
//                        .value
//                        .as(ArrayExprSyntax.self)

//                    print("ooo", type, type?.as(ArrayTypeSyntax.self))
//                    print("ooo", typeName)
                }

                guard let variableName, let typeName, let isOptional else {
                    return nil
                }

                return Variable(name: variableName, isOptional: isOptional, type: typeName)
            }

//        print(declaration.memberBlock.members.map(\.decl))

        let initialerA = try InitializerDeclSyntax("init()") {
//            for (variableName, isOptional, typeName) in variables {
//                "self.\(raw: variableName) = \(raw: variableName)"
//            }
        }

        let initialerC = try InitializerDeclSyntax("init(from decoder: Decoder) throws") {
            """
            let container = try decoder.container(keyedBy: CodingKeys.self)

            """

            for variable in variables {
//                if variable.isOptional == false {
//                    throw "no optional"
//                }

                """
                if let \(raw: variable.name)Value = try? container.decode(\(raw: variable.type).self, forKey: .\(raw: variable.name)) {
                    self.\(raw: variable.name) = \(raw: variable.name)Value
                }
                """
            }
        }

        return [
            // DeclSyntax(initialerA),
            DeclSyntax(initialerC)
        ]
    }

//    struct Err:Error,CustomStringConvertible {
//        case
//    }
}

extension String: Error {}

protocol MyCodable: Codable {
    var initialDefaultValue: Self { get }
}

extension String: MyCodable {
    var initialDefaultValue: String {
        ""
    }
}
