cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl 127.0.0.1:8070/ 2> /dev/null | diff - index_expected.out || echo "Failed index.html expected output test"
kill $PID
