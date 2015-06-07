xbrlware is written in Ruby. If you are looking to integrate xbrlware with other programming languages, this page might help you.

This page provides information on:





## Thrift ( C++, Java, Python, PHP, Ruby, Erlang, Perl, Haskell, C#, Cocoa, Smalltalk, and OCaml ) ##
### Introduction ###
[Thrift](http://developers.facebook.com/thrift/) is lightweight framework developed by Facebook to enable efficient and reliable communications across multiple languages. All datatypes and services are defined in a single language-neutral file and the necessary code is auto-generated for the developer by the 'thrift compiler'. Thrift will take care of the communications links, object serialization, and socket management. Thrift currently supports C++, Java, Python, PHP, Ruby, Erlang, Perl, Haskell, C#, Cocoa, Smalltalk, and OCaml.

Lets take an example to demonstrate how to use thrift in the context of xbrlware.

### Example - Python Integration ###

This example assumes you've downloaded, compiled, and installed the [thrift](http://developers.facebook.com/thrift/) (./configure && make && make install) in your computer.

A developer interested in creating risk rating computation service. The service depends on xbrlware to fetch necessary values of XBRL items from instance file. The service will be consumed by Python client (one of the languages supported by Thrift).

  * Create service in Ruby to compute risk rating.
    * Create rating.thrift file that defines two risk rating functions piotroski and altman\_z
```
namespace java org.risk.service
namespace cpp org.risk
namespace csharp Risk
namespace py risk
namespace php risk
namespace perl Risk
namespace rb Risk

service Rating {
   # compute Piotroski score 
   i16 piotroski(1:string edgar_filling_url),

   # compute Altman Z Score
   double altman_z(1:string edgar_filling_url)
}
```
    * We call the thrift generator to generate the required stubs in Ruby
```
thrift --gen rb rating.thrift # will create gen-rb folder and the generated files are stored under gen-rb
```
    * Next step is to provide the actual implementation of piotroski and altman\_z in rating-impl.rb. This file uses xbrlware to compute risk rating values
```
# provide an implementation of Rating service
class RatingImpl

  def piotroski(entity_name)
    # Code to use xbrlware goes here
    return 1 # return some dummy value
  end

  def altman_z(entity_name)
    # Code to use xbrlware goes here
    return 2.2567 # return some dummy value
  end
end
```
    * Integrate stubs with actual implementation in rating-server.rb.
```
$:.push('gen-rb')

require 'thrift'

require 'thrift/transport/server_socket'
require 'thrift/transport/buffered_transport'
require 'thrift/server/simple_server'

require 'rating'
require 'rating-impl'

# Thrift provides mutiple communication endpoints
#  - Here we will expose our service via a TCP socket
#  - Web-service will run as a single thread, on port 9090

handler = RatingImpl.new()
processor = Risk::Rating::Processor.new(handler)

transport = Thrift::ServerSocket.new(9090)
transportFactory = Thrift::BufferedTransportFactory.new()
server = Thrift::SimpleServer.new(processor, transport, transportFactory)

puts "Starting the Rating service..."
server.serve()
```
  * Create client in python to consume risk ratings
    * We call the thrift generator to generate the required stubs in Python
```
thrift --gen py rating.thrift # will create gen-py folder and the generated files are stored under gen-py
```
    * Create Python code to consume ratings in rating-client.py
```
import sys

sys.path.append("gen-py")

from thrift.transport import TTransport
from thrift.transport import TSocket
from thrift.protocol import TBinaryProtocol

from risk import Rating
from risk.ttypes import *

transport = TTransport.TBufferedTransport(TSocket.TSocket("localhost", "9090"))
protocol = TBinaryProtocol.TBinaryProtocol(transport)

client = Rating.Client(protocol)
transport.open()

print client.piotroski("JAVA")
print client.altman_z("GOOG")
```

Start the risk rating service
```
ruby rating-server.rb
```

Consume risk ratings
```
python rating-client.py
```

## R (Statistical Computing) ##
R is a famous software system and language for statistical computing and graphics.
  * [Integration via RinRuby](http://www.jstatsoft.org/v29/i04/paper)
  * [Integration via RSRuby](http://github.com/alexgutteridge/rsruby) and [RSRuby Manual](http://web.kuicr.kyoto-u.ac.jp/~alexg/rsruby/manual.pdf)

## Mathematica ##
  * [Integration via Mathlink](http://wolfram.com/solutions/mathlink/mathlink.html)

## Java ##
If you are in Java, you could leverage the support for standard scripting API (JSR223) .
[Click here](http://kenai.com/projects/jruby/pages/JavaIntegration) to see detailed instructions on configuring and using scripting API with JRuby.

## .NET ##
If you are using .NET, you could leverage DLR hosting capability. Click [here](http://ironruby.net/Documentation/.NET/Hosting) and [here](http://blogs.msdn.com/seshadripv/archive/2008/07/28/various-ways-to-execute-script-using-the-dlr-hosting-api.aspx) to see detailed instructions.

## Other techniques ##
You could also try with other integration techniques such as SOA, Webservice, Message Queues, Fileystem/Database, Sockets etc.