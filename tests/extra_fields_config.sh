cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
python3 ../webserv.py ../extra_fields_config.cfg | diff - config_not_found.out || echo "Failed extra fields in config test"
kill $PID
