cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl -I 127.0.0.1:8070/note.xml 2> /dev/null | grep 'HTTP/1.1' | diff - xml_status.out || echo "Failed xml status code output test"
kill $PID