//
//  MyPlaceTests.swift
//  MyPlaceTests
//
//  Created by Peter Szücs on 2021-03-10.
//

import XCTest
import MapKit
@testable import MyPlace

class MyPlaceTests: XCTestCase {
    
    // map typechange Function
    func test_map_type() {
        let vm = MapViewModel()
        let hybrid = MKMapType.hybrid
        
        vm.updateMapType()
        
        XCTAssertEqual(hybrid, vm.mapType)
    }

}

class TestLRUCache: XCTestCase {
    
    let cache = LRUCache<String, String>(capacity: 6)
    
    func test_empty() {
        XCTAssert(cache.linkedList.head == nil)
        XCTAssert(cache.linkedList.tail == nil)
        XCTAssert(cache.linkedList.count == 0)
    }
    
    func test_adding_one() {
        cache.setObject(for: "TestCase", value: "TestingOneObject")
        
        XCTAssert(cache.linkedList.head?.payload.key == "TestCase")
        XCTAssert(cache.linkedList.tail?.payload.key == "TestCase")
        XCTAssert(cache.linkedList.head?.payload.value == "TestingOneObject")
        XCTAssert(cache.linkedList.tail?.payload.value == "TestingOneObject")
        XCTAssert(cache.linkedList.count == 1)
        XCTAssert(cache.dictionary["TestCase"]?.payload.value == "TestingOneObject")
    }
    
    func test_duplicate_objects() {
        cache.setObject(for: "One", value: "First")
        cache.setObject(for: "Two", value: "Second")
        cache.setObject(for: "Two", value: "Third")
        
        XCTAssert(cache.linkedList.head?.payload.key == "Two")
        XCTAssert(cache.linkedList.tail?.payload.key == "One")
        XCTAssert(cache.linkedList.head?.payload.value == "Third")
        XCTAssert(cache.linkedList.tail?.payload.value == "First")
        XCTAssert(cache.linkedList.count == 2)
        
        XCTAssert(cache.dictionary.count == 2)
        XCTAssert(cache.dictionary["One"]?.payload.value == "First")
        XCTAssert(cache.dictionary["Two"]?.payload.value == "Third")
    }
    
    func test_adding_to_full() {
        cache.setObject(for: "One", value: "First")
        cache.setObject(for: "Two", value: "Second")
        cache.setObject(for: "Three", value: "Third")
        cache.setObject(for: "Four", value: "Fourth")
        cache.setObject(for: "Five", value: "Fifth")
        cache.setObject(for: "Six", value: "Sixth")
        cache.setObject(for: "Seven", value: "Seventh")
        
        XCTAssert(cache.linkedList.head?.payload.key == "Seven")
        XCTAssert(cache.linkedList.tail?.payload.key == "Two")
        XCTAssert(cache.linkedList.head?.payload.value == "Seventh")
        XCTAssert(cache.linkedList.tail?.payload.value == "Second")
        XCTAssert(cache.linkedList.count == 6)
        
        XCTAssert(cache.dictionary.count == 6)
        XCTAssert(cache.dictionary["One"]?.payload.value == nil)
        XCTAssert(cache.dictionary["Two"]?.payload.value == "Second")
        XCTAssert(cache.dictionary["Three"]?.payload.value == "Third")
        XCTAssert(cache.dictionary["Four"]?.payload.value == "Fourth")
        XCTAssert(cache.dictionary["Five"]?.payload.value == "Fifth")
        XCTAssert(cache.dictionary["Six"]?.payload.value == "Sixth")
        XCTAssert(cache.dictionary["Seven"]?.payload.value == "Seventh")
    }
    
    func test_loading_one() {
        cache.setObject(for: "One", value: "First")
        cache.setObject(for: "Two", value: "Second")
        cache.setObject(for: "Three", value: "Third")
        cache.setObject(for: "Four", value: "Fourth")
        cache.setObject(for: "Five", value: "Fifth")
        cache.setObject(for: "Six", value: "Sixth")
        cache.setObject(for: "Seven", value: "Seventh")

        XCTAssert(cache.retrieveObject(at: "Five") == "Fifth")
    }
}
