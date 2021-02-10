cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl -I 127.0.0.1:8070/missing.html 2> /dev/null | grep '404' | diff - 404_status_expected.out || echo "Failed 404 status output test"
kill $PID
