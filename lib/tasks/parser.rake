#    This file is part of TuneZombie.
#    Copyright 2012 Greg Lincoln
#
#    TuneZombie is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    TuneZombie is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with TuneZombie.  If not, see <http://www.gnu.org/licenses/>.

require 'crawler'

namespace :tz do

  desc """
Loads media into the TuneZombie database.
   source_path: Path where your media files are currently.
   dest_path: Path where TuneZombie will store your media files.
   user: Username under which any metadata will be added.
   itunes_xml: Full path to the itunes XML file.
"""
  task :crawl => :environment do |t|
    if ENV['source_path'].blank? || ENV['dest_path'].blank? || ENV['user'].blank?
      puts "Please provide a value for source_path, dest_path and user."
    else
      c = Crawler.new(username: ENV['user'], path_to_search: ENV['source_path'],
                      dest_path: ENV['dest_path'], itml_file: ENV['itunes_xml'])
      c.crawl
    end
  end

end


