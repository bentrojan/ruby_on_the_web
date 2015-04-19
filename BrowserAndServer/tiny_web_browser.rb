require 'rubygems'
require 'socket'
require 'json'

host = 'localhost'
port = 2000
path = "index.html"
post_path = "thanks.html"

request_get = "GET #{path} HTTP/1.0\r\n\r\n"

puts "do you want to send a GET or POST?"
type = ""

until type == "GET" || type == "POST"
	type = gets.chomp.upcase
end

socket = TCPSocket.open(host, port) 			# Connect to server


if type == "GET"
	socket.puts request_get
else
	puts "Ok, you will now register for the Viking Raid"
	print "Name: "
	name = gets.chomp
	print "email: "
	email = gets.chomp
	data = { :viking => { :name => name, :email => email } }
	jsondata = data.to_json
	socket.puts "POST #{post_path} HTTP/1.0" 
	socket.puts "" 
	socket.puts "#{jsondata}\r\n\r\n"
	#socket.puts "From: #{email}"
	#socket.puts "Content-Type: application/x-www-form-urlencoded"
	#socket.puts "Content-Length: #{data.length}"
	#socket.puts "#{data.to_json}"

end



response = socket.read

headers, body = response.split("\r\n\r\n", 2)
print "#{headers}  #{body}"