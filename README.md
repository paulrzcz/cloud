# cloud

This is the test of distributed-process library on "real-life" task

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
  * monad-logger (fast-logger?)
* Testing
  * The larger your score is, the better.
  * Properties to test: message processing.
  * Failure tests
* Other considerations
