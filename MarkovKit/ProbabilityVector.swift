//
//  ProbabilityVector.swift
//  MarkovKit
//
//  Created by Sam Williams on 12/17/15.
//  Copyright © 2015 Sam Williams. All rights reserved.
//

import Foundation

public class ProbabilityVector<T:Hashable> {
    private var itemsToProbabilities:[T:Double] = [:]
    
    private var needsNormalization:Bool = true
    
    public init(items:[T], probabilities:[Double]=[]) {
        let defaultValue:Double = 1.0/Double(items.count)
        for i in 0..<items.count {
            let item = items[i]
            let p = i < probabilities.count ? probabilities[i] : defaultValue
            self[item] = p
        }
    }
    
    public func probabilityOfItem(item:T) -> Double? {
        self.normalizeIfNeeded()
        
        return self.itemsToProbabilities[item]
    }

    public func setProbabilityOfItem(item:T, _ probability:Double) {
        self.itemsToProbabilities[item] = probability
        self.needsNormalization = true
    }
    
    public subscript(item:T) -> Double? {
        get {
            return self.probabilityOfItem(item)
        }
        set {
            self.setProbabilityOfItem(item, newValue ?? 0)
        }
    }
    
    public func randomItem() -> T? {
        self.normalizeIfNeeded()
        
        let random = Double(arc4random()) / Double(UINT32_MAX)
        let items = Array(self.itemsToProbabilities.keys)
        var sum:Double = 0
        for i in 0..<items.count {
            let item = items[i]
            sum = sum + (self[item] ?? 0)
            if sum > random {
                return items[i]
            }
        }
        return items.last
    }
    
    private func normalize() {
        var total:Double = 0
        for p in self.itemsToProbabilities.values {
            total = total + p
        }
        var normalizer:Double = 0
        if total != 0 {
            normalizer = 1.0/total
        }
        for (item, p) in self.itemsToProbabilities {
            self[item] = normalizer * p
        }
    }
    
    private func normalizeIfNeeded() {
        if self.needsNormalization {
            self.normalize()
            self.needsNormalization = false
        }
    }
    
    
}