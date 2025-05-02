#!/usr/bin/env ruby
require 'date'
require 'fileutils'

TODAYS_DATE     = "%Y-%m-%d"
ARCHIVE_FOLDER = "Archives"

def cleanup(folder)
  # Only include top-level items to preserve nested directory structure and avoid conflicts
  source_dir  = File.join(Dir.home, folder)
  source      = Dir.glob(File.join(source_dir, "*"))
  destination = File.join(Dir.home, ARCHIVE_FOLDER, Time.now.strftime(TODAYS_DATE), folder)

  FileUtils.mkdir_p destination
  FileUtils.move source, destination
end

cleanup("Desktop")
cleanup("Downloads")
cleanup("Documents")

require 'date'
require 'fileutils'

def compress_archives!(days_threshold = 30)
  archive_base = File.join(Dir.home, ARCHIVE_FOLDER)
  Dir.glob(File.join(archive_base, "*")).sort.each do |archive|
    folder_name = File.basename(archive)

    # Attempt to parse the folder name as a date using the defined format.
    begin
      case folder_name
      when /^(\d{4}-\d{2}-\d{2}).tar.gz$/
        raise ArgumentError, "Already compressed"
      when /^(\d{4}-\d{2}-\d{2})$/
        archive_date = Date.strptime(folder_name, TODAYS_DATE)
      else
        raise ArgumentError, "Invalid format"
      end
    rescue ArgumentError => e
      puts "Skipping #{archive}: #{e.message}"
      next
    end

    # Calculate the age in days of the archive folder.
    age_in_days = (Date.today - archive_date).to_i
    if age_in_days > days_threshold
      tar_file = File.join(archive_base, "#{folder_name}.tar.gz")
      puts "Compressing #{archive} (#{age_in_days} days old) to #{tar_file}..."
      
      # Use the tar command to compress the folder.
      # The -C flag changes directory to the archive_base so that the folder's relative path is preserved.
      if system("tar -czf #{tar_file} -C #{archive_base} #{folder_name}")
        FileUtils.rm_rf(archive)
        puts "Successfully compressed and removed #{archive}"
      else
        puts "Failed to compress #{archive}. Check permissions and available space."
      end
    end
  end
end

compress_archives!