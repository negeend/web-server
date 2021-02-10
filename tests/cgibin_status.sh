cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl -I localhost:8070/cgibin/hello.py 2> /dev/null | grep 'HTTP/1.1' | diff - cgibin_status.out || echo "Failed CGI script status output test"
kill $PID
