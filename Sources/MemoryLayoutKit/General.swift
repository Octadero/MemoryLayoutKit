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

public protocol ByteRepresentable {
	mutating func encode() -> Data
	mutating func encodePointer() -> UnsafePointer<Int8>
}

public extension ByteRepresentable {
	mutating func encode() -> Data {
		return withUnsafePointer(to: &self) { (pointer) in
			Data(bytes: pointer, count: MemoryLayout<Self>.size)
		}
	}
	
	mutating func encodePointer() -> UnsafePointer<Int8> {
		return self.encode().withUnsafeBytes({ (p : UnsafePointer<Int8>) -> UnsafePointer<Int8> in
			return p
		})
	}
}

