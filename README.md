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
* By specification, the calculation process should stop waiting after the sender process finished. How to coordinate them if they did not start at the same moment. There are two ways to solve it:
  * Stop cycle after send-for time, read all messages in the mailbox and after that print out the value.
  * Try to coordinate all senders by message passing (like register sender, unregister sender) and stop cycle after all senders are unregistered. Though the spec defines wait-for time when the process should be killed. This approach is too complicated and requires clarifications on the spec.

# Development plan
* Command line arguments √
  * --send-for k
  * --wait-for l
  * --with-seed s
  * ~~--some parameters for distributed-process startup `[(host, port)]`~~
  * Node list is embedded into NodeList.hs
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
  * Given that RNG is uniformly distributed and result is (N, S) than E[S] = (N+1) * N / 4
