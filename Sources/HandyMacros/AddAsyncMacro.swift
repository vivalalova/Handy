import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct AddAsyncMacro: PeerMacro {
    enum AsyncError: Error, CustomStringConvertible {
        case onlyFunction

        var description: String {
            switch self {
            case .onlyFunction:
                return "@AddAsync can be attached only to functions."
            }
        }
    }

    public static func expansion(of node: AttributeSyntax, providingPeersOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        guard let functionDecl = declaration.as(FunctionDeclSyntax.self) else {
            throw AsyncError.onlyFunction
        }

        guard let signature = functionDecl.signature.as(FunctionSignatureSyntax.self) else {
            return []
        }

        let parameters = signature.parameterClause.parameters

        guard let completion = parameters.last,
              let completionType = completion.type.as(FunctionTypeSyntax.self)?.parameters.first,
              let remainPara = FunctionParameterListSyntax(parameters.removingLast()) else {
            return []
        }

        let functionArgs = remainPara
            .map { parameter -> String in
                guard let paraType = parameter.type.as(IdentifierTypeSyntax.self)?.name else {
                    return ""
                }

                return "\(parameter.firstName): \(paraType)"
            }
            .joined(separator: ", ")

        let calledArgs = remainPara
            .map { "\($0.firstName): \($0.firstName)" }
            .joined(separator: ", ")

        return [
            """
            func \(functionDecl.name)(\(raw: functionArgs)) async -> \(completionType) {
              await withCheckedContinuation { continuation in
                self.\(functionDecl.name)(\(raw: calledArgs)) { object in
                  continuation.resume(returning: object)
                }
              }
            }
            """
        ]
    }
}
