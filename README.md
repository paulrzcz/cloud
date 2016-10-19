# cloud

This is the test of distributed-process library on "real-life" task

# Network topology configuration

Due to test nature of this solution, the simple node list is kept in the app/src/NodeList.hs.
_Please modify it before run!_

# Catches and non-clarities
* Each message contains a deterministic random number n ∈ (0, 1].
  * There is no distribution of random number. In order to optimize the goal (higher value is better), the distribution could be \delta(x-1).
* |m| is a kind of norm. Sum uses it as a length of list and that is approximately l0-norm, though messages with zero results are excluded by RNG definition.
* We should keep node list, therefore, we cannot use SimpleLocalnet stuff.

# Development plan
* Command line arguments √
  * --send-for k
  * --wait-for l
  * --with-seed s
  * some parameters for distributed-process startup `[(host, port)]`
* Random number generators
  * System
  * Mersienne-Twister √
* Messages
  * Message data type √
  * Calculation of tuple (it seems to be a monoid computation or kind of) √
  * Message sending code
* Communication between nodes
  * distributed-process (study!)
  * obviously there are two types of nodes: those "several" and "other nodes"
    * several nodes send messages
    * every message reach every node
* Debug configuration
  * To stderr only
  * monad-logger (fast-logger?) Nope! there is say :: String -> Process ()
* Testing
  * The larger your score is, the better.
  * Properties to test: message processing.
  * Failure tests
* Other considerations
