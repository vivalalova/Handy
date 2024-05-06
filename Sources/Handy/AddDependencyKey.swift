//
//  File.swift
//
//
//  Created by Lova on 2024/5/5.
//

import Foundation

@attached(extension, conformances: Codable)
public macro AddDependencyKey() = #externalMacro(module: "HandyMacros", type: "AddDependencyKeyMacro")
