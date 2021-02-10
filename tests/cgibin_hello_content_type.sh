cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl -I localhost:8070/cgibin/hello.py 2> /dev/null | grep 'Content-Type' | diff - cgibin_hello_content_type.out || echo "Failed CGI script content type test"
kill $PID
