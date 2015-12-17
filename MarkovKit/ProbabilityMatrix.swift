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
public class ProbabilityMatrix<SourceStateType:Hashable, DestinationStateType:Hashable> {
    public typealias RowType = ProbabilityVector<DestinationStateType>
    
    /// The probabilities of each destination state without an initial state.
    private var initialProbabilities:RowType = ProbabilityVector()
    
    /// The probabilities of transitioning from each source state to each output state.
    private var rows:[SourceStateType: RowType] = [:]
    
//    public var sourceStates:[SourceStateType]
//    public var destinationStates:[DestinationStateType]
    
//    public init(sourceStates:[SourceStateType], destinationStates:[DestinationStateType]) {
//        self.sourceStates = sourceStates
//        self.destinationStates = destinationStates
//    }

    public init() {
    }
    
    public init(sourceStates:[SourceStateType], destinationStates:[DestinationStateType], CSVString string:String) {
        let lines = string.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        for i in 0..<lines.count {
            let line = lines[i]
            let state = sourceStates[i]
            let vector = ProbabilityVector<DestinationStateType>(items: destinationStates, CSVString: line)
            self.rows[state] = vector
        }
    }
    
    public func probabilitiesFromState(state:SourceStateType?) -> RowType? {
        if let state = state {
            return self.rows[state]
        } else {
            return self.initialProbabilities
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