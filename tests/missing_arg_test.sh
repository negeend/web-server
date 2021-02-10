cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
python3 ../webserv.py | diff - missing_arg.out || echo "Failed missing configuration file argument test"
kill $PID
