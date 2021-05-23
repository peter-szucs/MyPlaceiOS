//
//  LRUCache.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-23.
//

import Foundation

class LRUCache<T: Hashable, U> {
    // total capacity
    private(set) var capacity: UInt
    // Linked list
    private(set) var linkedList = DoublyLinkedList<CachePayload<T, U>>()
    // Dictionary
    private(set) var dictionary = [T: Node<CachePayload<T, U>>]()
    
    required init(capacity: UInt) {
        self.capacity = capacity
    }
    
    // Set value at key
    func setObject(for key: T, value: U) {
        let element = CachePayload(key: key, value: value)
        let node = Node(value: element)
        
        if let existingNode = dictionary[key] {
            linkedList.moveToHead(node: existingNode)
            linkedList.head?.payload.value = value
            dictionary[key] = node
        } else {
            if linkedList.count == capacity {
                if let leastAccessedKey = linkedList.tail?.payload.key {
                    dictionary[leastAccessedKey] = nil
                }
                linkedList.remove()
            }
            linkedList.insert(node: node, at: 0)
            dictionary[key] = node
        }
    }
    
    // Get value for key
    func retrieveObject(at key: T) -> U? {
        guard let existingNode = dictionary[key] else {
            return nil
        }
        linkedList.moveToHead(node: existingNode)
        return existingNode.payload.value
    }
}

extension LRUCache {
    public subscript(key: T) -> U? {
        get {
            return self.retrieveObject(at: key)
        }
        set(newValue) {
            guard let value = newValue else {
                return
            }
            self.setObject(for: key, value: value)
        }
    }
}
