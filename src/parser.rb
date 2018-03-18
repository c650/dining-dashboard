#!/usr/bin/env ruby

require "nokogiri"
require "open-uri"
require "json"

require 'net/http'
require 'cgi'

require_relative "./grabber.rb"
require_relative "./dish.rb"

module Parser

	# https://stackoverflow.com/questions/1252210/parametrized-get-request-in-ruby
	# def Parser.http_get(domain,path,params)
	# 	return Net::HTTP.get(domain, "#{path}?".concat(params.collect { |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&'))) if not params.nil?
	# 	return Net::HTTP.get(domain, path)
	# end

	def Parser.parameterize(params)
		return "" if params.nil?
		params.collect { |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&')
	end

	# Gets meal period links for specified location_name
	# returns an array.
	def Parser.get_meal_periods(location_name)
		html = Nokogiri::HTML(Grabber.grab(location_name))

		params = html.text.match(/requestParameters:([^}]*})/)[0].to_s
		         .gsub(/storeId:\s* undefined,/,"")
		         .gsub(/\s+/,"")
		         .gsub(/requestParameters:/,"")
				 .gsub("\'","\"").gsub(/([a-zA-Z]+):/){|m|"\"#{$1}\":"}

		# puts params
		params = JSON.parse(params)

		periods = html.text.match(/periods:[^\]]*\]/)[0].to_s.gsub(/\s+/,"").gsub("\'","\"").gsub(/([a-zA-Z]+):/){|m|"\"#{$1}\":"}
		periods = JSON.parse("{#{periods}}")["periods"]

		res = periods.map do |period|
			params["periodId"] = period["periodId"]
			{url: "https://ucf.campusdish.com/api/menus/GetMenu/?#{self.parameterize(params)}", name: period["name"]}
		end
	end

	# Grabs the menu for one specific meal time,
	# the meal time pointed to by period_url
	# Returns a hash table of the menu.
	def Parser.parse_a_period(data)

		period_url = data[:url]
		meal_name = data[:name]

		ret = {}

		html = Nokogiri::HTML(open(period_url))
		html.css(".menu__station").each do |station|
			name = station.css(".stationName").first.text

			ret[name] = []

			begin
				station.css(".menu__item").each do |item|
					title = item.css(".item__name a").first.text
					description = item.css(".item__content").first.text

					# allergens = item.css(".allergenList li").map(&:text).map(&:strip).join(", ")
					allergens = []
					item.each do |k,v|
						if k.match(/contains/) && v == "True"
							fancy = k.gsub(/contains(.*)/){|m| "#{$1.capitalize}"}
							allergens << fancy
						end
					end

					description = "#{description} (Allergens: #{allergens.join(", ")})" unless allergens.empty?
					ret[name] << Dish.new(title, description)
				end
			rescue
			end
		end

		# return a map of the entire menu with the key of which meal period it is.
		return {meal_name => ret}
	end

	# This function takes in the location_name (as a string), uses Grabber.grab
	# to retrieve the HTML, and processes the menu into a hash table,
	# which is returned.
	# It does it for every meal of the day.
	def Parser.parse(location_name)
		# that's right. functional method chains for the win.
		self.get_meal_periods(location_name).map{|data| self.parse_a_period(data)}.reduce(Hash.new, &:merge)
	end
end
