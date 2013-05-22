TuneZombie [![Code Climate](https://codeclimate.com/github/tetious/TuneZombie.png)](https://codeclimate.com/github/tetious/TuneZombie)
==========

TuneZombie is a open source Ruby on Rails based music server.

TuneZombie eats your tunes. It will not yet read your runes.  
It matters not, as we don't care. Reading runes would not be fair.

*Tilverton lives!*

Usage
=====

TuneZombie is probably not ready for general usage yet, however Greg (tetious) is using it as his main library right now, so 
it probably won't eat your tunes. Well, not permanently at least. 

If you'd like to hack on it, by all means do so. If not, we'll have a proper preview release in the near future. 

To get started, you'll want to add some music to the library. For now, this is a somewhat manual process.

1. Add a user for yourself from the rails console. 
2. Have a look at lib/tasks/db.rake for settings rows you'll need to add. We'll have a web UI to edit these soon.
3. Run tz:crawl to import your music. It will make copies of your media files (unless you pass in move_files=true), so make sure you have disk space.

If everything worked, you should have a library to play with. Remember that many things aren't implemented, or are buggy, or might cause zombies to 
appear and eat your music. Pull requests or patches are gladly accepted. Have fun! 

License
=======
    TuneZombie is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    TuneZombie is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.
