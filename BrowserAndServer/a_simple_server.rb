require 'socket'
require 'json'

server = TCPServer.open(2000)


loop do 
	client = server.accept
	
	request = ""
	while line = client.gets
		request << line
		break if request =~ /\r\n\r\n$/
	end

	command = request.split(" ")[0]
	
	if command == "GET"
		line = request.split(" ")
		path = line[1]
		http_version = line[2]

		if File.exist?(path)
			file = File.open(path, "r")
			client.puts "#{http_version} 200 OK"
			client.puts ""
			client.puts "Content-Type: #{path.match(/\.\w+/)}"
			client.puts "Content.Length: #{file.size}\n"
			client.puts "\n #{file.readlines.join("")}"

		else
			client.puts "#{http_version} 404 Not Found"
			client.puts "derrrrrrP"
		end


	elsif command == "POST"
		lines = request.split("\n")
		lines.pop

		line_one = lines[0].split(" ")
		path = line_one[1]
		http_version = line_one[2]
		
		json = lines[-1].strip

		params = {}
		params = JSON.parse(json)

		viking_name = params["viking"]["name"]
		viking_email = params["viking"]["email"]

		if File.exist?(path)
			file = File.open(path, "r")
			
			client.puts "#{http_version} 200 OK"
			client.puts ""
			client.puts "Content-Type #{path.match(/\.\w+/)}"
			client.puts "Content-Length: #{file.size}\n"
			client.puts "#{file.each do |l|
										if l.match(/<%= yield %>/)
											client.puts "<li>Name: #{viking_name}</li>"
											client.puts "<li>Email: #{viking_email}</li>"
										else 
											client.puts l
										end		
									end
									}"
						
		else	
			client.puts	"#{http_version} 404 Not Found"
		end
		
	end
							
	client.close
end




