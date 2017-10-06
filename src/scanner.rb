#!/usr/bin/env ruby

# Module to scan menu items in hash table for possible allergens.
module Scanner

	KEYWORDS = [
		"peanut",
		"nut"
	]

	class Flag
		attr_reader :meal_p, :station, :dish
		def initialize(meal_p, station, dish)
			@meal_p = meal_p
			@station = station
			@dish = dish
		end
	end

	# Scans menu for possible allergens according to dish descriptions.
	# Returns an Array of Flags.
	def Scanner.scan_menu(menu)
		results = []
		menu.each do |meal_period|
			# puts meal_period
			meal_period.each do |station, stuff|
				puts station
				puts stuff
				stuff.each do |dish, desc|
					unless check_dish(dish, desc)
						results << Flag.new(meal_period, station, dish)
					end
				end
			end
		end
		return results
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
