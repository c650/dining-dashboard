require_relative "../src/scanner.rb"
require_relative "../src/parser.rb"

require "pp"

pp Scanner.scan_menu(Parser.parse("knightro\'s"))
