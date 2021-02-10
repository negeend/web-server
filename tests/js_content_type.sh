cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl -I localhost:8070/home.js 2> /dev/null | grep 'Content-Type' | diff - js_content_type.out || echo "Failed javascript file content type test"
kill $PID