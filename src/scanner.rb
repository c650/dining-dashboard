#!/usr/bin/env ruby

require "json"

# Module to scan menu items in hash table for possible allergens.
module Scanner

	KEYWORDS = []

	def Scanner.load_keywords
		# take first argument to program as filepath if it exists.
		filepath = ARGV.empty? ? "./keywords.json" : ARGV.first

		KEYWORDS << JSON.parse(File.read(filepath))["keywords"]
		KEYWORDS.flatten!
	end

	# Scans menu for possible allergens according to dish descriptions.
	def Scanner.scan_menu(menu)

		# load the keywords if there are none.
		load_keywords if KEYWORDS.empty?

		menu.each do |meal_period, stations|
			stations.each do |station, dishes|
				dishes.each{|dish| dish.flagged = !Scanner.check_dish(dish.name, dish.description)}
			end
		end
	end

	# Checks if a dish contains any of the keywords.
	# Returns true if it's clear (i.e., no keywords present)
	# false otherwise.
	def Scanner.check_dish(dish, desc)
		clear = true
		KEYWORDS.each do |word|
			# puts "#{dish} : #{desc}"
			clear = clear && !(dish.downcase.include?(word) || desc.downcase.include?(word))
		end
		return clear
	end
end
