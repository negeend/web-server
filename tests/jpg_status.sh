cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl -I 127.0.0.1:8070/image.jpg 2> /dev/null | grep 'HTTP/1.1' | diff - jpg_status.out || echo "Failed jpg status code output test"
kill $PID