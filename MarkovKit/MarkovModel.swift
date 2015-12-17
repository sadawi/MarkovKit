//
//  MarkovModel.swift
//  MarkovKit
//
//  Created by Sam Williams on 12/17/15.
//  Copyright © 2015 Sam Williams. All rights reserved.
//

import Foundation

public class MarkovModel<StateType:Hashable>: ProbabilityMatrix<StateType, StateType> {
    
    /**
     Generates a stochastic chain from an initial state, which can be nil.
     */
    public func generateChainFrom(initialState:StateType?, length:Int, continueCondition:([StateType] -> Bool)?) -> [StateType] {
        var result:[StateType] = []
        if let initialState = initialState {
            result.append(initialState)
        }
        var state = initialState
        while result.count < length {
            state = self.transitionFromState(state)
            if let state = state {
                result.append(state)
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