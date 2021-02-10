cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl 127.0.0.1:8070/jpeg_image.jpeg 2> /dev/null | diff - jpeg_expected.out || echo "Failed jpeg expected output test"
kill $PID