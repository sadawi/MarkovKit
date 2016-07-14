//
//  MarkovKitTests.swift
//  MarkovKitTests
//
//  Created by Sam Williams on 12/17/15.
//  Copyright © 2015 Sam Williams. All rights reserved.
//

import XCTest
@testable import MarkovKit

class MarkovKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func vectorOuputFraction<T:Hashable>(_ vector:ProbabilityVector<T>, item: T) -> Double {
        var counts:[T:Int] = [:]
        let n = 1000
        for _ in 0..<n {
            if let value = vector.randomItem() {
                counts[value] = (counts[value] ?? 0) + 1
            }
        }
        let count = counts[item] ?? 0
        return Double(count)/Double(n)
    }
    
    func assertNear(_ value:Double, target:Double, delta:Double) {
        XCTAssertLessThan(fabs(value-target), delta)
    }
    
    func testProbabilityVector() {
        let delta = 0.05
        let colors = ["red", "blue", "green"]
        let vector = ProbabilityVector(items: colors)
        XCTAssertEqual(vector.probabilityOfItem("red"), Double(1)/Double(3))
        
        let vectorA = ProbabilityVector(items: colors, probabilities: [2, 1, 1])
        XCTAssertEqual(vectorA["red"], 0.5)
        
        let item = vector.randomItem()
        XCTAssertNotNil(item)
        
        assertNear(self.vectorOuputFraction(vector, item: "red"), target:0.33, delta:delta)

        let vector2 = ProbabilityVector<String>(items: colors, probabilities: [1, 0, 0])
        assertNear(self.vectorOuputFraction(vector2, item: "red"), target:1, delta:delta)

        let vector3 = ProbabilityVector<String>(items: colors, probabilities: [0.25, 0.25, 0.5])
        assertNear(self.vectorOuputFraction(vector3, item: "red"), target:0.25, delta:delta)

        
        let vectorB = ProbabilityVector<String>()
        vectorB["red"] = 1
        assertNear(self.vectorOuputFraction(vectorB, item: "red"), target:1.0, delta:delta)
        vectorB["green"] = 1
        assertNear(self.vectorOuputFraction(vectorB, item: "red"), target:0.5, delta:delta)
        vectorB["green"] = 0.25
        vectorB["red"] = 0.75
        assertNear(self.vectorOuputFraction(vectorB, item: "red"), target:0.75, delta:delta)
    }
    
    func testMatrix() {
        let matrix:ProbabilityMatrix<String, String> = [
            "a": ["b": 1],
            "1": ["2": 1],
            "x": ["y": 0.5, "z": 0.5]
        ]
        
        XCTAssertEqual(matrix.transitionFromState("a"), "b")
        XCTAssertEqual(matrix.transitionFromState("1"), "2")
        
        let either = matrix.transitionFromState("x")
        XCTAssertTrue(either == "y" || either == "z")
    }
    
    func testMarkov() {
        let model: MarkovModel<String> = [
            // a a a a a ...
            "a": ["a": 1],
            
            // 1 2
            "1": ["2": 1],
            
            // x y x y x y x y ...
            "x": ["y": 1],
            "y": ["x": 1],
        ]
        
        let aChain = model.generateChain(from: "a", maximumLength: 5)
        XCTAssertEqual(aChain, ["a", "a", "a", "a", "a"])
        
        let bChain = model.generateChain(from: "1", maximumLength: 5)
        XCTAssertEqual(bChain, ["1", "2"])

        let cChain = model.generateChain(from: "x", maximumLength: 5)
        XCTAssertEqual(cChain, ["x", "y", "x", "y", "x"])
        
        let dChain = model.generateChain(maximumLength: 5)
        XCTAssertEqual(dChain, [])
        
        model[nil] = ProbabilityVector(items: ["a"], probabilities: [1])
        let eChain = model.generateChain(maximumLength: 5)
        XCTAssertEqual(eChain, ["a", "a", "a", "a", "a"])
    }

    func testHMM() {
        // Example from https://en.wikipedia.org/wiki/Viterbi_algorithm
        
        let states = ["healthy", "sick"]
        let initialProbabilities:ProbabilityVector<String> = ["healthy": 0.6, "sick": 0.4]
        
        let transitionProbabilities:MarkovModel<String> = [
            "healthy":  ["healthy": 0.7, "sick": 0.3],
            "sick":     ["healthy": 0.4, "sick": 0.6],
        ]
        
        let emissionProbabilities: ProbabilityMatrix<String, String> = [
            "healthy":  ["normal": 0.5, "cold": 0.4, "dizzy": 0.1],
            "sick":     ["normal": 0.1, "cold": 0.3, "dizzy": 0.6],
        ]
        
        let hmm = HiddenMarkovModel(states:states, initialProbabilities: initialProbabilities, transitionProbabilities: transitionProbabilities, emissionProbabilities: emissionProbabilities)

        let observations = ["normal", "cold", "dizzy"]
        let prediction = hmm.calculateStates(observations)
        XCTAssertEqual(prediction, ["healthy", "healthy", "sick"])
    }
    
}
