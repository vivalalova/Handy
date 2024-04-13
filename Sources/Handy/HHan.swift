//
//  HHan.swift
//  test
//
//  Created by Lova on 2024/4/3.
//

import SwiftUI

struct User: Codable {
    var name: String?
    var age: Int?

    var posts: [Post] = []

    struct Post: Codable {
        var title: String?
    }

//    private enum CodingKeys: String, CodingKey {
//        case name
//        case age
//        case posts
//    }

    private init() {}

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try? container.decodeIfPresent(String.self, forKey: .name)
        self.age = try? container.decode(Int.self, forKey: .age)
        self.posts = (try? container.decode([Post].self, forKey: .posts)) ?? []
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
