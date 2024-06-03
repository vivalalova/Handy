//
//  HHan.swift
//  test
//
//  Created by Lova on 2024/4/3.
//

import SwiftUI

@Codable
struct User: Codable {
    var name: String?
    var age: Int?

    var posts: [Post] = []

    @Codable
    struct Post {
        var title: String?
    }
}

let data = """
[{
    "name" : 1,
    "posts" : [
      {
        "title" : "haha"
      }
    ],
  "age" : 30
}]
"""

let users = User.array(from: data)
let string = users.toJSONString(pretty: true) ?? ""

#Preview {
    List {
        Text(string)
    }
}
