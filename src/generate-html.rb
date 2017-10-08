
require_relative "./parser.rb"
require_relative "./scanner.rb"

require "erb"

def generate(location)
	@menu = Parser.parse(location)
	Scanner.scan_menu(@menu)

	result = ERB.new(File.open("./dashboard.erb").read()).result()

	name = Array.new(10).map{rand(97..122).chr}.join("")
	name = "/tmp/#{name}.html"

	File.open(name, 'w'){|file| file.write(result)}

	puts "#{location}: file://#{name}"
end

generate("\'63 south")
generate("knightro\'s")
