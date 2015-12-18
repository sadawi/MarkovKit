[![Version](https://img.shields.io/cocoapods/v/MarkovKit.svg?style=flat)](http://cocoapods.org/pods/MarkovKit)
[![License](https://img.shields.io/cocoapods/l/MarkovKit.svg?style=flat)](http://cocoapods.org/pods/MarkovKit)
[![Platform](https://img.shields.io/cocoapods/p/MarkovKit.svg?style=flat)](http://cocoapods.org/pods/MarkovKit)

# MarkovKit

Some simple tools for working with probabilities and Markov models in Swift.

* `ProbabilityVector`: A mapping of items to probabilities (summing to 1)
* `ProbabilityMatrix`: A transition table mapping input states to output states
* `MarkovModel`: A `ProbabilityMatrix` where the input and output states are the same.  Can generate chains.
* `HiddenMarkovModel`: Implementation of the [Viterbi algorithm](https://en.wikipedia.org/wiki/Viterbi_algorithm) for obtaining a likely sequence of hidden states from a sequence of observations

## Installation

In your Podfile:

```
pod 'MarkovKit', '~> 0.6.0'
```

## Probability Vectors

```swift
let vector: ProbabilityVector<String> = ["red": 0.25, "blue": 0.5, "green": 0.25]
let item = vector.randomItem()  // should return "blue" about 50% of the time
```

## Markov Chains

```swift
let model: MarkovModel<String> = [
    "x": ["y": 1],
    "y": ["x": 1],
]
let chain = model.generateChain(from: "x", maximumLength: 5)
// always returns ["x", "y", "x", "y", "x"]
```

To start a chain without an initial state, initial probabilities must be given:

```swift
model.initialProbabilities = ["x": 1]
let newChain = model.generateChain(maximumLength: 5)

```


## Hidden Markov Models

```swift
let states = ["healthy", "sick"]
let initialProbabilities:ProbabilityVector<String> = ["healthy": 0.6, "sick": 0.4]

let transitionProbabilities:MarkovModel<String> = [
    "healthy":  ["healthy": 0.7, "sick": 0.3],
    "sick":     ["healthy": 0.4, "sick": 0.6],
]

// Note that the emission type isn't necessarily the same as the state type.
let emissionProbabilities: ProbabilityMatrix<String, String> = [
    "healthy":  ["normal": 0.5, "cold": 0.4, "dizzy": 0.1],
    "sick":     ["normal": 0.1, "cold": 0.3, "dizzy": 0.6],
]

let hmm = HiddenMarkovModel(states:states, 
    initialProbabilities: initialProbabilities, 
    transitionProbabilities: transitionProbabilities, 
    emissionProbabilities: emissionProbabilities)

let observations = ["normal", "cold", "dizzy"]
let prediction = hmm.calculateStates(observations)

// ["healthy", "healthy", "sick"]
```
