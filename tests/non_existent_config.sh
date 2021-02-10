cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
python3 ../webserv.py ../non_existant_config.cfg | diff - config_not_found.out || "Failed non-existent configuration file test"
kill $PID
