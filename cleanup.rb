#!/usr/bin/env ruby

require 'fileutils'

TODAYS_DATE     = "%Y-%m-%d"
ARCHIVE_FOLDER = "Archives"

def cleanup(folder)
  source      = Dir.glob(File.join(Dir.home, folder, "**"))
  destination = File.join(Dir.home, ARCHIVE_FOLDER, Time.now.strftime(TODAYS_DATE), folder)

  FileUtils.mkdir_p destination
  FileUtils.move source, destination
end

cleanup("Desktop")
cleanup("Downloads")
cleanup("Documents")
