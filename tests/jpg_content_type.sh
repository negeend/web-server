cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl -I 127.0.0.1:8070/image.jpg 2> /dev/null | grep 'Content-Type' | diff - jpg_content_type.out || echo "Failed jpg content type test"
kill $PID