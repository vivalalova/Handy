import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension VariableDeclSyntax {
    var name: String? {
        bindings
            .compactMap {
                $0.pattern.as(IdentifierPatternSyntax.self)?.identifier.text
            }
            .first
    }

    var type: String? {
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

    var initialValue: String? {
        if self.bindings.first?.typeAnnotation?.type is ArrayTypeSyntax {
            let elements = bindings.first?
                .initializer?.value
                .as(ArrayExprSyntax.self)?
                .elements
                .compactMap { $0.as(ArrayElementSyntax.self) }
                .compactMap {
                    $0.expression.as(IntegerLiteralExprSyntax.self)?.valueText
                }
                ?? []

            return "[\(elements.joined(separator: ","))]"
        }

        if let string = bindings.compactMap(\.initializer).first?.value.as(StringLiteralExprSyntax.self)?.valueText {
            return "\"\(string)\""
        }

        if let number = bindings.first?.initializer?.value.description {
            return number
        }

        return nil
    }

    var hasDefaultValue: Bool {
        if let isArray = self.bindings.compactMap(\.typeAnnotation).first?.type.as(ArrayTypeSyntax.self) {
            return true
        }

        if let string = bindings.compactMap(\.initializer).first?.value.as(StringLiteralExprSyntax.self)?.segments.first?.as(StringSegmentSyntax.self)?.content {
            return true
        }

        if let number = bindings.first?.initializer?.value {
            return true
        }

        return false
    }
}

protocol SyntaxValue {
    var valueText: String? { get }
}

extension IntegerLiteralExprSyntax: SyntaxValue {
    var valueText: String? {
        literal.text
    }
}

extension StringLiteralExprSyntax: SyntaxValue {
    var valueText: String? {
        segments.first?.as(StringSegmentSyntax.self)?.content.text
    }
}
