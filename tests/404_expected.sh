cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl 127.0.0.1:8070/missing.html 2> /dev/null | diff - 404_expected.out || echo "Failed 404 expected output test"
kill $PID
