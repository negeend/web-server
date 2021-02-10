cd ..
python3 webserv.py mixed_config.cfg &
PID=$!
cd tests
python3 ../webserv.py ../nonexistent_dir.cfg | diff - config_not_found.out || echo "Failed non-existent files in configuration file test"
kill $PID