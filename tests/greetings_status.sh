cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl -I 127.0.0.1:8070/greetings.html 2> /dev/null | grep '200 OK' | diff - greetings_status_expected.out || echo "Failed html file status output test"
kill $PID
