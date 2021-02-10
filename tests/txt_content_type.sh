cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl -I 127.0.0.1:8070/hello.txt 2> /dev/null | grep 'Content-Type' | diff - txt_content_type.out || echo "Failed text file content type test"
kill $PID