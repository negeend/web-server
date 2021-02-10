cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl -I 127.0.0.1:8070/note.xml 2> /dev/null | grep 'Content-Type' | diff - xml_content_type.out || echo "Failed xml file content type test"
kill $PID