#!/usr/bin/env ruby

require 'fileutils'

source      = Dir.glob("#{Dir.home}/Desktop/**")
destination = "#{Dir.home}/Archives/#{Time.now.strftime("%Y-%m-%d")}"

FileUtils.mkdir_p destination
FileUtils.move source, destination
