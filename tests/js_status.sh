cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl -I localhost:8070/home.js 2> /dev/null | grep 'HTTP/1.1' | diff - js_status.out || echo "Failed javascript status code output test"
kill $PID