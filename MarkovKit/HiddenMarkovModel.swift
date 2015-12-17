//
//  HiddenMarkovModel.swift
//  MarkovKit
//
//  Created by Sam Williams on 12/17/15.
//  Copyright © 2015 Sam Williams. All rights reserved.
//

import Foundation

struct Structure<StateType> {
    var prob:Double
    var vPath:[StateType]
    var vProb:Double
}

public class HiddenMarkovModel<StateType:Hashable, ObservationType:Hashable> {
    /// A list of possible hidden states
    public var states:[StateType]
    
    /// Prior probability distribution of the states
    public var initialProbabilities:ProbabilityVector<StateType>
    
    /// Probabilities of transitions between states
    public var transitionProbabilities:MarkovModel<StateType>;

    /// Probability of output observations for each state
    public var emissionProbabilities:ProbabilityMatrix<StateType, ObservationType>

    public init(
        states: [StateType],
        initialProbabilities: ProbabilityVector<StateType>,
        transitionProbabilities: MarkovModel<StateType>,
        emissionProbabilities: ProbabilityMatrix<StateType, ObservationType>
        )
    {
        self.states = states
        self.initialProbabilities = initialProbabilities
        self.transitionProbabilities = transitionProbabilities
        self.emissionProbabilities = emissionProbabilities
    }
    
    /**
     
     Viterbi algorithm
     
     Computes a likely sequence of hidden states that could have produced the observations.
     */
    public func calculateStates(observations:[ObservationType]) -> [StateType] {
        var t:[StateType:Structure<StateType>] = [:]
        for state in self.states {
            let p0 = self.initialProbabilities[state] ?? 0
            t[state] = Structure(prob: p0, vPath: [state], vProb: p0)
        }
        
        for output in observations {
            var u:[StateType:Structure<StateType>] = [:]
            for nextState in self.states {
                var total:Double = 0.0
                var argmax:[StateType] = []
                var valmax:Double = 0.0
                
                var prob:Double = 1.0
                var vPath:[StateType] = []
                var vProb = 1.0
                
                for sourceState in self.states {
                    let objs = t[sourceState]
                    prob = objs?.prob ?? 0.0
                    vPath = objs?.vPath ?? []
                    vProb = objs?.vProb ?? 0.0
                    
                    let p = self.emissionProbabilities.probabilityOfState(output, fromState: sourceState) * self.transitionProbabilities.probabilityOfState(nextState, fromState: sourceState)
                    prob = prob * p
                    vProb = vProb * p
                    total = total + prob
                    if vProb > valmax {
                        argmax = vPath + [nextState]
                        valmax = vProb
                    }
                }
                let newList = Structure(prob: total, vPath: argmax, vProb: valmax)
                u[nextState] = newList
            }
            t = u
        }
        
        var total:Double = 0.0
        var argmax:[StateType] = []
        var valmax:Double = 0.0
        
        var prob:Double
        var vPath:[StateType]
        var vProb:Double
        
        for state in self.states {
            let objs = t[state]
            prob = objs?.prob ?? 0.0
            vPath = objs?.vPath ?? []
            vProb = objs?.vProb ?? 0.0
            total = total + prob
            if vProb > valmax {
                argmax = vPath
                valmax = vProb
            }
        }
        
        var states:[StateType] = argmax
        
        // the algorithm leaves an extra state on the end
        states.removeLast()
        return states
    }
    
}