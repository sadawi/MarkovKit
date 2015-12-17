//
//  MarkovModel.swift
//  MarkovKit
//
//  Created by Sam Williams on 12/17/15.
//  Copyright © 2015 Sam Williams. All rights reserved.
//

import Foundation

public class MarkovModel<StateType:Hashable>: ProbabilityMatrix<StateType, StateType> {
    public override init() {
        super.init()
    }
    
    public init(states:[StateType], probabilitySets:[[Double]]) {
        super.init(sourceStates: states, destinationStates: states, probabilitySets: probabilitySets)
    }

    /**
     Generates a stochastic chain using the transition probabilities.
     
     - parameter from: The initial state.  If omitted or nil, initialProbabilities will be used to generate a first state.
     - parameter maximumLength: The desired length of the chain.  Not all states have outbound transitions, so the chain might terminate early.
     - parameter stopCondition: An optional test to stop the chain early, if desired.
     
     */
    public func generateChain(from initialState:StateType?=nil, maximumLength:Int, stopCondition:([StateType] -> Bool)?=nil) -> [StateType] {
        var result:[StateType] = []
        if let initialState = initialState {
            result.append(initialState)
        }
        var state = initialState
        while result.count < maximumLength && stopCondition?(result) != true {
            state = self.transitionFromState(state)
            if let state = state {
                result.append(state)
            } else {
                // A nil result means we can no longer transition from the current state.
                break
            }
        }
        return result
    }
    
//    /**
//    Generates a chain that satisfies a condition.
//    */
//    public func generateChainFrom(initialState:StateType, length:Int, condition:([StateType] -> Bool)) -> StateType {
//        
//    }
//    
    
}