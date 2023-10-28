//
//  DummyViewModel.swift
//  Link
//
//  Created by Lauren Ferlito on 10/28/23.
//

import Foundation

enum Direction {
    case ahead
    case behind
    case aheadRight
    case aheadLeft
    case left
    case right
    case behindLeft
    case behindRight
}

class DummyViewModel: ObservableObject {
    @Published var direction: Direction
    
    struct Friend {
        var name: String
        var direction: Direction
        var distanceAway: Int
    }
    
    let alecNipp = Friend(name: "Alec Nipp", direction: Direction.aheadRight, distanceAway: 7)
    
    init() {
            self.direction = .ahead // need to set an initial direction, but can be overrwitten
    }
}
