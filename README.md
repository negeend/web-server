# web-server

This is a common application which serves web pages and commonly executes queries as part of a request. It interacts with clients through the HTTP protocol, a client will send a HTTP request, the web server processes it and sens a HTTP response to the client.

The Common Gateway Interface is used by web-servers to allow compatible programs to be executed on the server, to process HTTP requests and compute a HTTP response. The web-server uses standard input and output as well as environment variables for communication between the CGI program and the itself. HTTP requests that are received by the web-server are passed to a CGI program via shell environment variables and standard input.

As an extension I chose to compress packets to send back to the client if requested to do so. The way which I implemented this within my server program is simply through checking whether the the client has
asked to accept the encoding gzip in their request. If this has been detected in the request header then the server compresses the body of the response which it is to send back to the client using the python gzip module.
Otherwise the data is just sent back to the client normally.

Test cases:
The test.sh script is to be run from the same directory as the server. 
