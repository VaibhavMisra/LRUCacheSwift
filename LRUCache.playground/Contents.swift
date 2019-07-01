import UIKit

enum CacheErrors: Error {
    case itemNotFound
}

public class LRUCache<KeyType: Hashable> {
    
    private var cache = [KeyType: Any]()
    private var priority = [KeyType]()
    
    public func evict() {
        let key = priority.remove(at: priority.endIndex-1)
        cache[key] = nil
    }
    
    public func add(key: KeyType, value: Any) {
        if let _ = cache[key], let index = priority.firstIndex(of: key) {
            priority.remove(at: index)
        }
        priority.insert(key, at: 0)
        cache[key] = value
    }
    
    public func get(key: KeyType) throws -> Any {
        guard let value = cache[key], let index = priority.firstIndex(of: key) else {
            throw CacheErrors.itemNotFound
        }
        priority.remove(at: index)
        priority.insert(key, at: 0)
        return value
    }
    
    public func remove(key: KeyType) throws -> Any {
        guard let value = cache[key], let index = priority.firstIndex(of: key) else {
            throw CacheErrors.itemNotFound
        }
        priority.remove(at: index)
        cache[key] = nil
        return value
    }
}



func performLRUOps() {
    let lru = LRUCache<Int>()
    lru.add(key: 5, value: 2)
    lru.add(key: 1, value: 2)
    try? lru.get(key: 5)
    lru.evict()
}

performLRUOps()
