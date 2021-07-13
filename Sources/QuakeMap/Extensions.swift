//
//  File.swift
//  
//
//  Created by Tobias Baumhöver on 12.07.21.
//

import Foundation
import struct Euclid.Vector
import struct Euclid.Vertex

extension Vector {
    public var isNaN: Bool {
        return self.x.isNaN || self.y.isNaN || self.z.isNaN
    }
}

extension Vertex {
    public init(position: Vector) {
        self.init(position, Vector(0, 0, 1))
    }
}
