//
//  Person.Swift
//  Attendance
//
//  Created by Mikael Weiss on 6/18/20.
//  Copyright © 2020 MikeStudios. All rights reserved.
//

import Foundation

struct Person: Identifiable, Codable {
    let id = UUID()
    //I don't quite understand why I have to include this, but I was told by Xcode to add it in order to silence a warning.
    enum CodingKeys: String, CodingKey {
        case id = "id"
    }
    var name: String = ""
    var isPresent: Bool = false
    var daysPresent: [Date]?
    
    init(_ name: String) {
        self.name = name
    }
    
    init(name: String, daysPresent: [Date]) {
        self.name = name
        self.daysPresent = daysPresent
    }
}

struct People: Codable {
    var list: [Person]
}
