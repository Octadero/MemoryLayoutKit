/* Copyright 2017 The Octadero Authors. All Rights Reserved.
 Created by Volodymyr Pavliukevych on 2017.
 
 Licensed under the Apache License 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 https://github.com/Octadero/MemoryLayoutKit/blob/master/LICENSE
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation

public struct CharStarConstStar: CustomStringConvertible {
    public enum CharStarConstStarError: Error {
        case canNotComputeCStringPointer
    }
    
    public let pointerList: UnsafeMutablePointer<UnsafePointer<Int8>?>
    public let count: Int
    public let encoding: String.Encoding
    public var sizes = [Int]()
    public init(array: [String], using encoding: String.Encoding) throws {
        count = array.count
        pointerList = UnsafeMutablePointer<UnsafePointer<Int8>?>.allocate(capacity: array.count)
        
        self.encoding = encoding
        for (i, value) in array.enumerated(){
            guard let cString = value.cString(using: encoding) else {
                throw CharStarConstStarError.canNotComputeCStringPointer
            }
            pointerList[i] = UnsafePointer<Int8>(strdup(cString))
            sizes.append(cString.count)
        }
    }
    
    public var deallocator: (() -> Void) {
        return {
            for index in 0..<self.count {
                let pointer = UnsafeMutablePointer(mutating: self.pointerList[index])
                pointer?.deallocate(capacity: self.sizes[index])
            }
            self.pointerList.deallocate(capacity: self.count)
        }
    }
    
    public var description: String {
        var description = ""
        for index in 0..<count {
            if let pointer = pointerList[index] {
                description += "[" + String(cString: pointer) + "]"
            }
        }
        return description
    }
}


extension Array where Element == String {
    /// Return C style array char* const* you can use it for const char* const* API.
    /// Do not forget to free memory at defer statement.
    public func cArray(using encoding: String.Encoding = .utf8) throws -> CharStarConstStar {
        return try CharStarConstStar(array: self, using: encoding)
    }
    
}
