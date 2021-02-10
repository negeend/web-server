cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl 127.0.0.1:8070/png_image.png 2> /dev/null | diff - png_expected.out || echo "Failed png file expected output test"
kill $PID