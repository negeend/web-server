cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl -I 127.0.0.1:8070/jpeg_image.jpeg 2> /dev/null | grep 'Content-Type' | diff - jpeg_content_type.out || echo "Failed jpeg content type test"
kill $PID