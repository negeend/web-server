cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl -I 127.0.0.1:8070/ 2> /dev/null | grep 'Content-Type' | diff - index_content_type.out || echo "Failed index.html content type test"
kill $PID