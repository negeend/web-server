cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl 127.0.0.1:8070/greetings.html 2> /dev/null | diff - greetings_expected.out || echo "Failed html file output test"
kill $PID