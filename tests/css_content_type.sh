cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl -I 127.0.0.1:8070/mystyle.css 2> /dev/null | grep 'Content-Type' | diff - css_content_type.out || echo "Failed css file content type test"
kill $PID