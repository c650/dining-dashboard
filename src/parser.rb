#!/usr/bin/env ruby

require "nokogiri"
require "open-uri"

require_relative "./grabber.rb"

module Parser

	# Gets meal period links for specified location_name
	# returns an array.
	def Parser.get_meal_periods(location_name)
		html = Nokogiri::HTML(Grabber.grab(location_name))
		html.css("a.menu-period").map do |period|
			"#{Grabber::LINK_FRONT}#{period["href"]}"
		end
	end

	# Grabs the menu for one specific meal time,
	# the meal time pointed to by period_url
	# Returns a hash table of the menu.
	def Parser.parse_a_period(period_url)
		ret = {}

		html = Nokogiri::HTML(open(period_url))
		html.css(".menu-details-station").each do |station|
			name = station.css("h2").first.text

			ret[name] = {}

			begin
				station.css(".menu-details-station-item a").each do |item|
					data_content = Nokogiri::HTML(item["data-content"])
					title = data_content.css(".title").first.text
					description = data_content.css(".description").first.text
					ret[name][title] = description
				end
			rescue
			end
		end

		# return a map of the entire menu with the key of which meal period it is.
		return {html.css(".mealSelected").first.text.strip => ret}
	end

	# This function takes in the location_name (as a string), uses Grabber.grab
	# to retrieve the HTML, and processes the menu into a hash table,
	# which is returned.
	# It does it for every meal of the day.
	def Parser.parse(location_name)
		# that's right. functional method chains for the win.
		self.get_meal_periods(location_name).map{|p_url| self.parse_a_period(p_url)}.reduce(Hash.new, &:merge)
	end
end
