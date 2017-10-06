#!/usr/bin/env ruby

# Module to scan menu items in hash table for possible allergens.
module Scanner

	KEYWORDS = [
		"peanut",
		"nut"
	]

	class Flag
		attr_reader :meal_p, :station, :dish, :desc
		def initialize(meal_p, station, dish, desc)
			@meal_p = meal_p
			@station = station
			@dish = dish
			@desc = desc
		end

		def to_s
			"#{@meal_p}: #{@station} -> #{@dish} (#{@desc})"
		end
	end

	# Scans menu for possible allergens according to dish descriptions.
	def Scanner.scan_menu(menu)
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
			clear = clear && !(dish.include?(word) || desc.include?(word))
		end
		return clear
	end
end
