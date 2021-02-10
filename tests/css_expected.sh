cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl 127.0.0.1:8070/mystyle.css 2> /dev/null | diff - css_expected.out || echo "Failed css file output test"
kill $PID