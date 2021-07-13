//
//  File.swift
//  
//
//  Created by Tobias Baumhöver on 12.07.21.
//

import struct Euclid.Vector


public struct Polygon {
    public let normal: Vector
    public var lineLoopIndices : [Int]
    public var indices: [Int]
    
    public init(_ normal: Vector) {
        self.normal = normal
        self.lineLoopIndices = []
        self.indices = []
    }
}
