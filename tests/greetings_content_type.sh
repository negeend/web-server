cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl -I 127.0.0.1:8070/greetings.html 2> /dev/null | grep 'Content-Type' | diff - greetings_content_type.out || echo "Failed html content type output test"
kill $PID