cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
python3 ../webserv.py ../invalid_config_2.cfg | diff - missing_field.out || echo "Failed missing field in configuration file test"
kill $PID
