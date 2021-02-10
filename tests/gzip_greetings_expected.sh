cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl -H "Accept-Encoding: gzip" 127.0.0.1:8070/greetings.html 2> /dev/null | gunzip -c | diff - greetings_expected.out || echo "Failed html file compress test"
kill $PID