cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl -I 127.0.0.1:8070/png_image.png 2> /dev/null | grep 'HTTP/1.1' | diff - png_status.out || echo "Failed png file status code output test"
kill $PID