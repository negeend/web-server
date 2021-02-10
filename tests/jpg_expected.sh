cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl 127.0.0.1:8070/image.jpg 2> /dev/null | diff - jpg_expected.out || echo "Failed jpg expected output test"
kill $PID