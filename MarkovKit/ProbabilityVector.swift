//
//  ProbabilityVector.swift
//  MarkovKit
//
//  Created by Sam Williams on 12/17/15.
//  Copyright © 2015 Sam Williams. All rights reserved.
//

import Foundation

public class ProbabilityVector<T:Hashable>: DictionaryLiteralConvertible {
    public typealias Key = T
    public typealias Value = Double
    
    private var items:[T] = []
    private var probabilities:[Double] {
        get {
            return self.items.map { self.itemsToProbabilities[$0]! }
        }
        set {
            let defaultValue:Double = 1.0/Double(items.count)
            for i in 0..<self.items.count {
                let item = self.items[i]
                let p = i < newValue.count ? newValue[i] : defaultValue
                self.itemsToProbabilities[item] = p
            }
            self.needsNormalization = true
        }
    }
    
    private var itemsToProbabilities:[T:Double] = [:]
    private var needsNormalization:Bool = true

    public init(items:[T]) {
        self.items = items
        self.probabilities = []
    }

    public init(items:[T], probabilities:[Double]) {
        self.items = items
        self.probabilities = probabilities
    }
    
    public init(items:[T], CSVString string:String) {
        self.items = items
        self.readProbabilitiesFromCSVString(string)
    }
    
    public required init(dictionaryLiteral elements: (Key, Value)...) {
        for (key, value) in elements {
            self[key] = value
        }
    }
    
    public func probabilityOfItem(_ item:T) -> Double {
        self.normalizeIfNeeded()
        return self.itemsToProbabilities[item] ?? 0
    }

    public func setProbabilityOfItem(_ item:T, _ probability:Double) {
        self.itemsToProbabilities[item] = probability
        self.needsNormalization = true
    }
    
    public subscript(item:T) -> Double {
        get {
            return self.probabilityOfItem(item)
        }
        set {
            if !self.items.contains(item) {
                self.items.append(item)
            }
            self.setProbabilityOfItem(item, newValue)
        }
    }
    
    public func randomItem() -> T? {
        self.normalizeIfNeeded()
        
        let random = Double(arc4random()) / Double(UINT32_MAX)
        var sum:Double = 0
        for i in 0..<self.items.count {
            let item = self.items[i]
            sum = sum + (self[item] ?? 0)
            if sum > random {
                return self.items[i]
            }
        }
        return self.items.last
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

    internal class func parseCSV(_ string:String) -> [Double] {
        let separator = ","
        
        var probabilities:[Double] = []
        for value in string.components(separatedBy: separator) {
            let value = value.trimmingCharacters(in: CharacterSet.whitespaces)
            let probability = Double(value) ?? 0
            probabilities.append(probability)
        }
        return probabilities
    }
    
    internal func readProbabilitiesFromCSVString(_ string:String) {
        self.probabilities = self.dynamicType.parseCSV(string)
    }
    
}
