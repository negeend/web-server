cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl -I localhost:8070/cgibin/custom_status.py 2> /dev/null | grep 'HTTP/1.1' | diff - cgibin_custom_status.out || echo "Failed CGI custom status test"
kill $PID
