//
//  MarkovModel.swift
//  MarkovKit
//
//  Created by Sam Williams on 12/17/15.
//  Copyright © 2015 Sam Williams. All rights reserved.
//

import Foundation

public class MarkovModel<StateType:Hashable>: ProbabilityMatrix<StateType, StateType> {
    
    public required init(dictionaryLiteral elements: (Key, Value)...) {
        super.init()
        for (key, value) in elements {
            self.setProbabilities(from: key, probabilities: value)
        }
    }
    
    /**
     Generates a stochastic chain using the transition probabilities.
     
     - parameter from: The initial state.  If omitted or nil, initialProbabilities will be used to generate a first state.
     - parameter maximumLength: The desired length of the chain.  Not all states have outbound transitions, so the chain might terminate early.
     - parameter stopCondition: An optional test to stop the chain early, if desired.
     
     */
    public func generateChain(from initialState:StateType?=nil, maximumLength:Int) -> [StateType] {
        var result:[StateType] = []
        if let initialState = initialState {
            result.append(initialState)
        }
        var state = initialState
        while result.count < maximumLength {
            state = self.transition(from: state)
            if let state = state {
                result.append(state)
            } else {
                // A nil result means we can no longer transition from the current state.
                break
            }
        }
        return result
    }
    
}
