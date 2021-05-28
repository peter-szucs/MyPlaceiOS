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

class TestBubbleSort: XCTestCase {
    var friends = [Friend(info: User(uid: "a1", firstName: "Karl", lastName: "Karlsson", userName: "karl", friends: [Friend()], places: [Place()]), status: ""),
                   Friend(info: User(uid: "b2", firstName: "Bert", lastName: "Bertsson", userName: "Berte", friends: [Friend()], places: [Place()]), status: ""),
                   Friend(info: User(uid: "c3", firstName: "Anders", lastName: "Andersson", userName: "anderz99", friends: [Friend()], places: [Place()]), status: ""),
                   Friend(info: User(uid: "d4", firstName: "Göran", lastName: "Göransson", userName: "Gorski", friends: [Friend()], places: [Place()]), status: ""),
                   Friend(info: User(uid: "e5", firstName: "Sven", lastName: "Svensson", userName: "mill4tre", friends: [Friend()], places: [Place()]), status: ""),
                   Friend(info: User(uid: "f5", firstName: "Harald", lastName: "Haraldsson", userName: "mill4u", friends: [Friend()], places: [Place()]), status: "")]
    
    func test_sort() {
        
        let sorted = friends.sortFriendsByUsername()
        
        XCTAssert(sorted[0].info.uid == "c3")
        XCTAssert(sorted[1].info.uid == "b2")
        XCTAssert(sorted[2].info.uid == "d4")
        XCTAssert(sorted[3].info.uid == "a1")
        XCTAssert(sorted[4].info.uid == "e5")
        XCTAssert(sorted[5].info.uid == "f5")
        print(sorted.prettyPrint())
        print(friends.prettyPrint())
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
