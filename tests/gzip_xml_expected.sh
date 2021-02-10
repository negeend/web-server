cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl -H "Accept-Encoding: gzip" 127.0.0.1:8070/note.xml 2> /dev/null | gunzip -c | diff - xml_expected.out || echo "Failed xml file compress test"
kill $PID