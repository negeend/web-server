cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl 127.0.0.1:8070/note.xml 2> /dev/null | diff - xml_expected.out || echo "Failed xml expected output test"
kill $PID