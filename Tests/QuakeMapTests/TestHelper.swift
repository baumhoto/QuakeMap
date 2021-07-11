//
//  TestHelper.swift
//  QuakeMapLoaderTests
//
//  Created by Tobias Baumhöver on 11.07.21.
//

import Foundation
import QuakeMap


class TestHelper {
    
    private static var instance: TestHelper?
    
    static func Instance() -> TestHelper {
        if instance == nil {
            instance = TestHelper()
        }
        
        return instance!
    }
    
    func getMapLoaderforMapfile(fileName: String) -> MapLoader? {
        //let bundle = Bundle.module.path(forR: type(of: self))
        guard let path = Bundle.module.path(forResource: "samples/\(fileName)", ofType: "map") else {
            // File not found ... oops
            return nil
        }
        let mapLoader = MapLoader(path)
        
        return mapLoader
    }
}
