cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl -I 127.0.0.1:8070/ 2> /dev/null | grep '200 OK' | diff - index_status_expected.out || echo "Failed index.html status output test"
kill $PID
