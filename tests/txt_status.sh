cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl -I 127.0.0.1:8070/hello.txt 2> /dev/null | grep 'HTTP/1.1' | diff - txt_status.out || echo "Failed text file status code output test"
kill $PID