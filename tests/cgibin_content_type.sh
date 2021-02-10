cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl -I localhost:8070/cgibin/content.py 2> /dev/null | grep 'Content-Type' | diff - cgibin_content_type.out || echo "Failed CGI script specified content type test"
kill $PID
