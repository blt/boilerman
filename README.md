# `boilerman` -- a persistent connection pool

[![Build Status](https://travis-ci.org/blt/boilerman.png)](https://travis-ci.org/blt/boilerman)

`boilerman` is intended to be useful when you need many persistent network
connections but cannot afford to keep these connections active at non-peak
times. Boiler man will:

  * persist a finite number of connections per network host
  * allow for checkin/checkout of these connections
  * allow expiration of non-active connections
  * distribute persisted connections across a cluster of nodes

## Usage

`boilerman` exports three main public functions:

  * checkout/2 :: Host -> SetupFun/1 -> Connection
  * checkin/3 :: Host -> Connection -> CloseFun/1 -> ok | {error, Reason}
  * with_connection :: Host -> SetupFun/1 -> CloseFun/1 -> (fun((Connection) -> any())) -> any()

The first two functions will retrieve and replace a connection per host, the
third performs retrieve and replace privately, applying a given function to the
resulting connection.

More elaborate forms of these functions will exist, though as of this writing
I'm unsure exactly what they'll be. Things I intend:

  * the ability to 'tag' a checkout/checkin; default tag being 'default'
  * the ability to change connection limits per host/tag combination
  * exposed asynchronous equivalents for the above functions
  * ability to change active TTL per connection

`boilerman` has two timeouts:

  * Active Time to Live :: the time, in milliseconds, that will elapse before an
    attempt is made to reclaim a connection that has not been checked out
  * Idle Time to Live :: the time, in milliseconds, that will elapse before a
    live connection not checked out will be closed

These timeouts will be alterable via option parameters.

## License

`boilerman` is released under the
[MIT license](http://opensource.org/licenses/MIT). See LICENSE for more details.
