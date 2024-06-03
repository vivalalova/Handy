```
@Codable
struct Model {
    var date: Date?
}
```

tobe

```
struct Model {
    var date: Date?

    init(date: Date? = nil) {
        self.date = date
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let dateValue = try? container.decode(Date?.self, forKey: .date) {
            self.date = dateValue
        }
    }
}

extension Model: Codable {
}
```
