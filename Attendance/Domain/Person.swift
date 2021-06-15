//
//  Person.Swift
//  Attendance
//
//  Created by Mikael Weiss on 6/18/20.
//  Copyright © 2020 MikeStudios. All rights reserved.
//

import Foundation

struct Person: Identifiable, Codable {
    let id: UUID
    var name: String = ""
    var isPresent: Bool = false
    var daysPresent: [Date]?
    
    init(_ name: String) {
        self.name = name
        self.id = UUID()
    }
    
    init(name: String, daysPresent: [Date]) {
        self.name = name
        self.daysPresent = daysPresent
        self.id = UUID()
    }
}

struct People: Codable {
    var list: [Person]
}
