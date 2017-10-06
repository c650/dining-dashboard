require_relative "../src/scanner.rb"
require_relative "../src/parser.rb"

puts Scanner.scan_menu(Parser.parse("knightro\'s"))
