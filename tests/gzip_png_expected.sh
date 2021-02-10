cd ..
python3 webserv.py config.cfg &
PID=$!
cd tests
curl -H "Accept-Encoding: gzip" 127.0.0.1:8070/png_image.png 2> /dev/null | gunzip -c | diff - png_expected.out || echo "Failed png file compress test"
kill $PID