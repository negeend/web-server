cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl -I 127.0.0.1:8070/png_image.png 2> /dev/null | grep 'Content-Type' | diff - png_content_type.out || echo "Failed png file content type test"
kill $PID