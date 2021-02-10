cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl localhost:8070/cgibin/sleepy.py 2> /dev/null | diff - cgi_sleepy_expected.out || echo "Failed CGI sleepy.py script output test" &
curl localhost:8070/cgibin/hello.py 2> /dev/null | diff - hello_expected.out || echo "Failed CGI script output test"
kill $PID