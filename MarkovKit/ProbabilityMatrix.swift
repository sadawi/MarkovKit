//
//  ProbabilityMatrix.swift
//  MarkovKit
//
//  Created by Sam Williams on 12/17/15.
//  Copyright © 2015 Sam Williams. All rights reserved.
//

import Foundation

/**
 A table of transition probabilities from a set of source states to a set of destination states (which may be the same as the source states, but isn't necessarily).
 
 There is a special row for initial states, since we're not treating nil as a valid state.
*/
public class ProbabilityMatrix<SourceStateType:Hashable, DestinationStateType:Hashable>: DictionaryLiteralConvertible {
    public typealias RowType = ProbabilityVector<DestinationStateType>

    public typealias Key = SourceStateType
    public typealias Value = RowType
    
    /// The probabilities of each destination state without an initial state.
    private var initialProbabilities:RowType = ProbabilityVector()
    
    /// The probabilities of transitioning from each source state to each output state.
    private var rows:[SourceStateType: RowType] = [:]
    
    public required init(dictionaryLiteral elements: (Key, Value)...) {
        for (key, value) in elements {
            self.setProbabilitiesFromState(key, probabilities: value)
        }
    }
    
    public init(sourceStates:[SourceStateType], destinationStates:[DestinationStateType], probabilitySets:[[Double]]) {
        for i in 0..<probabilitySets.count {
            let probabilities = probabilitySets[i]
            let vector = ProbabilityVector<DestinationStateType>(items: destinationStates, probabilities: probabilities)
            if i == 0 {
                self.initialProbabilities = vector
            } else {
                let state = sourceStates[i]
                self.rows[state] = vector
            }
        }
    }

    
    public convenience init(sourceStates:[SourceStateType], destinationStates:[DestinationStateType], CSVString string:String) {
        var probabilitySets:[[Double]] = []
        for line in string.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) {
            let probabilities = ProbabilityVector<SourceStateType>.parseCSV(line)
            probabilitySets.append(probabilities)
        }
        self.init(sourceStates: sourceStates, destinationStates: destinationStates, probabilitySets: probabilitySets)
    }
    
    public func probabilitiesFromState(state:SourceStateType?) -> RowType? {
        if let state = state {
            return self.rows[state]
        } else {
            return self.initialProbabilities
        }
    }
    
    public func setProbabilitiesFromState(state:SourceStateType?, probabilities:RowType) {
        if let state = state {
            self.rows[state] = probabilities
        } else {
            self.initialProbabilities = probabilities
        }
    }
    
    public subscript(state:SourceStateType?) -> RowType? {
        get {
            return self.probabilitiesFromState(state)
        }
        set {
            if let newValue = newValue {
                self.setProbabilitiesFromState(state, probabilities: newValue)
            }
        }
    }

    
    public func probabilityOfState(state:DestinationStateType, fromState initialState:SourceStateType?) -> Double {
        return self.probabilitiesFromState(initialState)?.probabilityOfItem(state) ?? 0
    }
    
    public func transitionFromState(state:SourceStateType?) -> DestinationStateType? {
        return self.probabilitiesFromState(state)?.randomItem()
    }
    
    public func inverted() -> Self {
        return self
    }
}