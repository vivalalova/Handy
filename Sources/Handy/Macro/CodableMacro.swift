

@attached(member, names: named(init(from:)), named(encode(to:)), arbitrary)
@attached(extension, conformances: Codable)
public macro Codable() = #externalMacro(module: "HandyMacros", type: "CodableMacro")

