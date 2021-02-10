cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl -I 127.0.0.1:8070/mystyle.css 2> /dev/null | grep 'HTTP/1.1' | diff - css_status.out || echo "Failed css file status output test"
kill $PID