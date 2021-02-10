cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl 127.0.0.1:8070/hello.txt 2> /dev/null | diff - txt_expected.out || echo "Failed text file expected output test"
kill $PID