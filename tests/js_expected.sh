cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl localhost:8070/home.js 2> /dev/null | diff - js_expected.out || echo "Failed javascript expected output test"
kill $PID
