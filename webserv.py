import sys
import socket
import os
import gzip
from os import listdir
from os.path import isfile, join

# Maps the file to the its content type based on the file extension
def getContentType(suffix):
    if suffix == "txt":
        return "text/plain"
    if suffix == "html":
        return "text/html"
    if suffix == "js":
        return "application/javascript"
    if suffix == "css":
        return "text/css"
    if suffix == "png":
        return "image/png"
    if suffix == "jpg" or suffix == "jpeg":
        return "image/jpeg"
    if suffix == "xml":
        return "text/xml"

# Reads a file and returns its contents as binary data
def getContents(filename):
	reply = "".encode()
	f = open(filename, "rb")
	for line in f:
		reply += line
	f.close()
	return reply

# Returns the file paths of all files in a directory or in the subdirectories
def getFilePaths(directory):
    files = os.listdir(directory)
    allFilePaths = []
    for file in files:
        filePath = os.path.join(directory, file)
        if os.path.isdir(filePath):
            allFilePaths = allFilePaths + getFilePaths(filePath)
        else:
            allFilePaths.append(filePath)
    return allFilePaths

# Takes in a list of file paths and return a list of only the file names
def getFileNames(filePaths):
    fileNames = []
    for filePath in filePaths:
        filePath = filePath.split("/")
        fileNames.append(filePath[len(filePath) - 1])
    return fileNames

# Is used to retrieve a list of all the files in the cgi directory 
def getCGIFiles(CGIdirectory):
	CGIFiles = os.listdir(CGIdirectory)
	return CGIFiles

# Parses the configuration file and returns a dictionary of each property and its value
def parseConfigFile(filename):
    properties = {}
    file = open(filename)
    lines = file.readlines()
    file.close()
    i = 0
    while i < len(lines):
        lines[i] = lines[i].strip("\n")
        lines[i] = lines[i].split("=")
        i += 1
    for line in lines:
        properties[line[0]] = line[1]
    return properties

# Takes in a cgi request and parses it to set the environment variables necessary for its execution and returns the the name of the file requested
def parseCGIRequest(request, config):
	configData = parseConfigFile(config)
	CGIVariables = {"Accept": "HTTP_ACCEPT", "Host": "HTTP_HOST", "User-Agent": "HTTP_USER_AGENT", "Accept-Encoding": "HTTP_ACCEPT_ENCODING"}
	header = request.split("\r\n")
	header[0] = header[0].split(" ")
	headers = {}
	for line in header:
		if line == "":
			header.remove(line)  # Removing any empty lines from the list
	i = 1
	while i < len(header):
		header[i] = header[i].split(": ")  # Starting from the second line, splits the lines so that each request header is broken up into its key and value
		i += 1
	i = 1
	while i < len(header):
		if len(header[i]) == 2:
			headers[header[i][0]] = header[i][1]  # Appends the key and value of each request header into a dictionary
		i += 1

	for var in CGIVariables:
		if var in headers: 
			os.environ[CGIVariables.get(var)] = headers.get(var)  # Creates an environment variable for each request header
	
	os.environ["SERVER_PORT"] = configData.get("port")
	os.environ["SERVER_ADDR"] = "127.0.0.1"
	os.environ["REQUEST_METHOD"] = header[0][0]
	os.environ["REQUEST_URI"] = header[0][1]

	return header[0][1]  # Returns the filename which is requested

# Runs the cgi script and returns the status, content-type and content body based on the output of the script.
def runCGI(filepath, config):
	r,w = os.pipe()
	pid = os.fork()
	config = parseConfigFile(config)

	if "?" in filepath:  # Checks whether the request URI contains query strings. If true, extracts the filename without the query strings accordingly
		f = filepath.split("?")
		f1 = f[0].split("/")
		filename = f1[len(f1) - 1]
	else:
		f = filepath.split("/")
		filename = f[len(f) - 1]
	response = "HTTP/1.1 200 OK\n"

	if pid == 0:  # Child process
		try:
			os.close(r)
			os.dup2(w, 1)
			filepath = config['cgibin'] + "/" + filename
			os.execle(config["exec"], 'python3', filepath, os.environ)
		except OSError:
			sys.exit(1)
		
	elif pid > 0:  # Parent process
		status = os.wait()
		os.close(w)
		f = open("childOutput", "w")
		fd = os.fdopen(r, "r")
		for line in fd:
			f.write(line)
		f.close()
		fd.close()

	# Error handling
	elif pid < 0:
		response = "HTTP/1.1 500 Internal Server Error\n"
	if status[1] != 0:
		response = "HTTP/1.1 500 Internal Server Error\n"

	# Constructing the response to send back to the client
	content = ""
	content_type = "Content-Type: text/html\n"
	f = open("childOutput", "r")
	for line in f:
		if "Content-Type" in line:  # Checking whether the cgi script defines its own content-type
			content_type = line
		elif "Status-Code" in line:  # Checking whether the cgi script defines its own status code
			response = "HTTP/1.1 " + line.split(": ")[1]
		else:
			content += line.strip("\n")
	content += "\n"
	f.close()
	return [response, content_type, content]

# Parses the request, determines whether it is a cgi script or static file and contructs the response accordingly
def parse(request, config):
	parts = request.split("\r\n")
	parts[0] = parts[0].split(" ")
	i = 1
	while i < len(parts):
		parts[i] = parts[i].split(": ")
		i += 1
	
	properties = parseConfigFile(config)
	staticfiles = properties.get("staticfiles")
	CGIdirectory = properties.get("cgibin")

	filePaths = getFilePaths(staticfiles) 
	fileNames = getFileNames(filePaths)
	CGIFiles = getCGIFiles(CGIdirectory)

	if "?" in parts[0][1]:  # Checking for the existence of query strings in the request URI
		querieString = parts[0][1].split("?")
		filepath = querieString[0]
		filename = filepath.split("/")[len(filepath.split("/"))- 1]  # Extracts the filename from the URI
		queries = querieString[1]
		os.environ["QUERY_STRING"] = queries  # Sets the query string as an environment variable
	else:
		if parts[0][1] == "/":  # Checks for the special case of the HTTP request on '/'
			filename = "index.html"
			filepath = staticfiles + "/" + filename
		elif parts[0][1].split("/")[1] == "cgibin":  # Extracts the filename if it is a cgi request
			filename = parts[0][1].split("/")[2]
		else:
			filename = parts[0][1].replace("/", "")

	response = "HTTP/1.1"
	if filename in fileNames:  # Checks whether the file is a static file
		file2 = filename.split(".")
		suffix = file2[1]
		index = fileNames.index(filename)
		response += " 200 OK\n"
		content_type = "Content-Type: {}\n".format(getContentType(suffix))
		content = getContents(filePaths[index])
	elif filename in CGIFiles:  # Checks whether the file is in the cgibin directory
		filePath = parseCGIRequest(request, config)
		CGIOut = runCGI(filePath, config)
		response = CGIOut[0]
		if response == "HTTP/1.1 500 Internal Server Error\n":
			content_type = ""
		else:
			content_type = CGIOut[1]
		content = CGIOut[2].encode()
	else:  # If failing the two previous cases then the file is not found
		file2 = filename.split(".")
		suffix = file2[1]
		response += " 404 File not found\n"
		content_type = "Content-Type: {}\n".format(getContentType(suffix))
		content = '<html>\n<head>\n\t<title>404 Not Found</title>\n</head>\n<body bgcolor="white">\n<center>\n\t<h1>404 Not Found</h1>\n</center>\n</body>\n</html>\n'.encode()
	return [response.encode(), content_type.encode(), content]

# Checks whether the configuration file is valid and returns the name of the config file
def checkConfig():
	if len(sys.argv) < 2:  # Handles the situation where the configuration file is not given as an arguement
		print("Missing Configuration Argument")
		sys.exit()
	config = sys.argv[1]
	try:  # Handles the situation where the file is not found
		file = open(config)
		lines = file.readlines()
		file.close()
	except FileNotFoundError:
		print("Unable To Load Configuration File")
		sys.exit()

	if len(lines) < 4:  # Handles missing fields in the configuration file
		print("Missing Field From Configuration File")
		sys.exit()

	if len(lines) > 4:  # Handles the situation where extra fields are given in the configuration file
		print("Unable To Load Configuration File")
		sys.exit()

	properties = parseConfigFile(config)
	if (not 'staticfiles' in properties) or (not 'cgibin' in properties) or (not 'port' in properties) or (not 'exec' in properties):  # Checks for missing fields
		print("Missing Field From Configuration File.")
		sys.exit()

	if os.path.isdir(properties.get('staticfiles')) == False:  # Checks whether the path to the static files exists and can be accessed
		print("Unable To Load Configuration File")
		sys.exit()
	if os.path.isdir(properties.get('cgibin')) == False:  # Checks whether the path to the cgi scripts exists and can be accessed
		print("Unable To Load Configuration File")
		sys.exit()
	return config

def main():
	config = checkConfig()  # Calls function which checks the configuration file
	port = parseConfigFile(config).get("port")

	s = socket.socket(socket.AF_INET, socket.SOCK_STREAM) 
	s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEPORT, 1)
	s.bind(("127.0.0.1", int(port))) 
	s.listen()
	while True:
		client, clientAddress = s.accept()
		request = client.recv(1024).decode("utf-8")
		pid = os.fork()
		if pid == 0:
			reply = parse(request, config)
			client.send(reply[0])
			if "Accept-Encoding: gzip" in request:  # Checks whether the reponse needs to be compressed
				reply[2] = gzip.compress(reply[2])
			client.send(reply[1] + "\n".encode() + reply[2])
			client.close()
		else:
			client.close()
			continue

if __name__ == '__main__':
	main()