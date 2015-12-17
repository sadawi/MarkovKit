# MarkovKit

Some simple tools for working with probabilities and Markov models in Swift.

* `ProbabilityVector`: A mapping of items to probabilities (summing to 1)
* `ProbabilityMatrix`: A transition table mapping input states to output states
* `MarkovModel`: A `ProbabilityMatrix` where the input and output states are the same.  Can generate chains.
* `HiddenMarkovModel`: Implementation of the [Viterbi algorithm](https://en.wikipedia.org/wiki/Viterbi_algorithm) for obtaining a likely sequence of hidden states from a sequence of observations

