cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl -H "Accept-Encoding: gzip" 127.0.0.1:8070/missing.html 2> /dev/null | gunzip -c | diff - 404_expected.out || echo "Failed 404 output compress test"
kill $PID