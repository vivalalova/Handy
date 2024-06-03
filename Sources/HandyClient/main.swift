import Handy

let a = 17
let b = 25

let (result, code) = #stringify(a + b)

print("The value \(result) was produced by the code \"\(code)\"")

import SwiftUI

//@AddEnvironmentKey
enum Catalog {
    static let defaultValue: Double = 1
}

extension Catalog: EnvironmentKey {
}

extension EnvironmentValues {
    var catalog: Double {
        get { self[Catalog.self] }
        set { self[Catalog.self] = newValue }
    }
}

extension View {
    func catalog(_ value: Double) -> some View {
        environment(\.catalog, value)
    }
}

// struct YY {
//    static let defaultValue: Double = 1
// }
//
// extension YY: EnvironmentKey {}
//
// extension EnvironmentValues {
//    var yy: Double {
//        get { self[YY.self] }
//        set { self[YY.self] = newValue }
//    }
// }
//
// extension View {
//    func yy(_ value: Double) -> some View {
//        environment(\.yy, value)
//    }
// }
