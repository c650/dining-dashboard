#!/usr/bin/env ruby

require "open-uri"

module Grabber
	LINK_FRONT = "https://ucf.campusdish.com"
	ROUTE = "/Commerce/Catalog/Menus.aspx?LocationId="
	LOCATION_IDS = {
		"knightro\'s" => "3020",
		"\'63 south" => "3018"
	}

	# This function just grabs the page HTML if such a page exists.
	# Otherwise, empty string.
	# location_name is a string that details which location to search.
	def Grabber.grab(location_name)
		name = location_name.downcase
		return (LOCATION_IDS.has_key? name) ? open("#{LINK_FRONT}#{ROUTE}#{LOCATION_IDS[name]}") : ""
	end
end
