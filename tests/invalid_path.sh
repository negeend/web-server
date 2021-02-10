cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
python3 ../webserv.py invalid | diff - invalid_path.out || echo "Failed non-existent configuration file test"
kill $PID
