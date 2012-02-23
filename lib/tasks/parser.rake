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

    import_user = env_or_setting('import_user')
    source_path = env_or_setting('source_path')
    dest_path = env_or_setting('dest_path')
    itunes_xml_path = env_or_setting('itunes_xml_path')
    move_files = env_or_setting('move_files')

    if import_user.blank? || source_path.blank? || dest_path.blank?
      puts "Please provide a value for source_path, dest_path and user."
    else
      c = Crawler.new(username: import_user, path_to_search: source_path,
                      dest_path: dest_path,  itml_file: itunes_xml_path, move_files: move_files)
      c.crawl
    end
  end

private

  def env_or_setting(key)
    ENV[key].blank? ? Settings.find_by_key(key).try(:value) : ENV[key]
  end


end


