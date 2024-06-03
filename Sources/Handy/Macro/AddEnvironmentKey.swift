//
//  File.swift
//  
//
//  Created by Lova on 2024/6/3.
//

import Foundation

@attached(extension, conformances: Codable)
public macro AddEnvironmentKey() = #externalMacro(module: "HandyMacros", type: "AddEnvironmentKeyMacro")
