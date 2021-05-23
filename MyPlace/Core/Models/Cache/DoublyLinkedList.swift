//
//  DoublyLinkedList.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-23.
//

import Foundation

public protocol Payload {
    associatedtype Key
    associatedtype Value
    
    var key: Key { get set }
    var value: Value { get set }
}

public struct CachePayload<T: Hashable, U>: Payload {
    public var key: T
    public var value: U
    
    public init(key: Key, value: Value) {
        self.key = key
        self.value = value
    }
}

public class Node<T: Payload> {
    
    public var payload: T
    public var previous: Node<T>?
    public var next: Node<T>?
    
    public init(value: T) {
        self.payload = value
    }
}

public class DoublyLinkedList<T: Payload> {
    public var head: Node<T>?
    public var tail: Node<T>?
    var isEmpty: Bool {
        return head == nil && tail == nil
    }
    
    public var count: Int = 0
    
    public init() {}
    
    public func prettyPrint() {
        var nodesPayload = [T]()
        var currentNode = head
        while currentNode != nil {
            if let payload = currentNode?.payload {
                nodesPayload.append(payload)
            }
            currentNode = currentNode?.next
        }
        for payload in nodesPayload {
            print("\(payload.key): \(payload.value)", terminator: " -> ")
        }
    }
    
    // find node at index or nil if no nodes
    func node(at index: Int) -> Node<T>? {
        guard !isEmpty || index == 0 else {
            return head
        }
        var node = head
        for _ in stride(from: 0, to: index, by: 1) {
            node = node?.next
        }
        return node
    }
    
    // Add node from value
    func add(value: T) {
        let node = Node(value: value)
        
        guard !isEmpty else {
            head = node
            tail = node
            count += 1
            return
        }
        node.previous = tail
        tail?.next = node
        tail = node
        count += 1
    }
    
    // Insert value at index, returns bool if successful or not
    public func insert(value: T, at index: Int) -> Bool {
        guard !isEmpty else {
            add(value: value)
            return true
        }
        guard case 0..<count = index else {
            print("Not here")
            return false
        }
        let newNode = Node(value: value)
        var currentNode =  head
        for _ in stride(from: 0, to: index - 1, by: 1) {
            currentNode = currentNode?.next
        }
        if currentNode === head {
            if head === tail {
                newNode.next = head
                head?.previous = newNode
                head = newNode
            } else {
                newNode.next = head
                head = newNode
            }
            count += 1
            return true
        }
        
        newNode.previous = currentNode
        newNode.next = currentNode?.next
        currentNode?.next?.previous = newNode
        currentNode?.next = newNode
        
        count += 1
        return true
    }
    
    // Insert node at index, returns bool if successful or not
    public func insert(node: Node<T>, at index: Int) -> Bool {
        guard !isEmpty else {
            head = node
            tail = node
            count += 1
            return true
        }
        
        guard case 0..<count = index else {
            return false
        }
        var currentNode = head
        for _ in stride(from: 0, to: index, by: 1) {
            currentNode = currentNode?.next
        }
        if currentNode === head {
            if head === tail {
                node.next = head
                head?.previous = node
                head = node
            } else {
                node.next = head
                head = node
            }
            count += 1
            return true
        }
        node.previous = currentNode
        node.next = currentNode?.next
        currentNode?.next?.previous = node
        currentNode?.next = node
        
        count += 1
        return true
    }
    
    // Remove, returns bool if successful or not
    func remove(at index: Int) -> Bool {
        guard case 0..<count = index else {
            return false
        }
        var currentNode = head
        for _ in stride(from: 0, to: index, by: 1) {
            currentNode = currentNode?.next
        }
        if currentNode === head {
            if head === tail {
                head = nil
                tail = nil
            } else {
                head?.next?.previous = nil
                head = head?.next
            }
            count -= 1
            return true
        }
        currentNode?.previous?.next = currentNode?.next
        currentNode?.next?.previous = currentNode?.previous
        
        count -= 1
        return true
    }
    
    // Remove last element of linkedlist
    public func remove() -> Bool {
        guard !isEmpty else {
            return false
        }
        if head === tail {
            head = nil
            tail = nil
            count -= 1
            return true
        }
        tail?.previous?.next = nil
        tail = tail?.previous
        count -= 1
        return true
    }
    
    public func moveToHead(node: Node<T>) {
        guard !isEmpty else {
            return
        }
        if head === node && tail === node {
            // nothing to move
        } else if head === node {
            // cant move head to head
        } else if tail === node {
            tail?.previous?.next = nil
            tail = tail?.previous
            let previousHead = head
            head?.next?.previous = node
            head = node
            head?.next = previousHead
        } else {
            var currentNode = head
            while currentNode?.next !== node && currentNode !== tail {
                currentNode = currentNode?.next
            }
            currentNode?.next = node.next
            node.next?.previous = currentNode
            let previousHead = head
            head = node
            head?.next = previousHead
            previousHead?.previous = head
        }
    }
}
