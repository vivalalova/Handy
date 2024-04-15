import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension VariableDeclSyntax {
    var variableName: String? {
        bindings
            .compactMap {
                $0.pattern.as(IdentifierPatternSyntax.self)?.identifier.text
            }
            .first
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

    var defaultValue: Bool {
        let isArray = self.bindings.compactMap(\.typeAnnotation).first?.type.as(ArrayTypeSyntax.self)

        return false
    }
}
