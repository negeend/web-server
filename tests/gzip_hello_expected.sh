cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl -H "Accept-Encoding: gzip" localhost:8070/cgibin/hello.py 2> /dev/null | gunzip -c | diff - hello_expected.out || echo "Failed CGI script compress test"
kill $PID