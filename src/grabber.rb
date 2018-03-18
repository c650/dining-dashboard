#!/usr/bin/env ruby

require "open-uri"

module Grabber
	LINK_FRONT = "https://ucf.campusdish.com"
	ROUTE = "/en/LocationsAndMenus/"
	LOCATION_IDS = {
		"knightro\'s" => "Knightros",
		"\'63 south" => "63South"
	}

	# This function just grabs the page HTML if such a page exists.
	# Otherwise, empty string.
	# location_name is a string that details which location to search.
	def Grabber.grab(location_name)
		name = location_name.downcase
		return (LOCATION_IDS.has_key? name) ? open(Grabber.make_link(location_name)) : ""
	end

	def Grabber.make_link(location_name)
		"#{LINK_FRONT}#{ROUTE}#{LOCATION_IDS[location_name]}"
	end
end
