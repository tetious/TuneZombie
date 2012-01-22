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
  desc "Find new media to load"
  task :media, [:username] => :environment do |t, args|
    # TODO: get paths from config
    path = '/Volumes/Big/tmp/music'
    dest = '/Volumes/Big/TuneZombie/Music'
    itml = '/Volumes/Big/tmp/iml.xml'

    c = Crawler.new(username: args.username, path_to_search: path,
                    dest_path: dest, itml_file: itml)
    c.crawl
  end
end


