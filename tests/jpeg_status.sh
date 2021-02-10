cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl -I 127.0.0.1:8070/jpeg_image.jpeg 2> /dev/null | grep 'HTTP/1.1' | diff - jpeg_status.out || echo "Failed jpeg status code output test"
kill $PID