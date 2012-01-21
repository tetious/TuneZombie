require 'URI'

def hash_file(file_name)
  file_h = Digest::SHA2.new
  File.open(path_to_file, 'r') do |fh|
    while buffer = fh.read(1024)
      file_h << buffer
    end
  end
  file_h
end

class MusicLibrary

  attr_accessor :library

  def initialize
    @library = Hash.new
  end

  def load(filename)
    file = open(filename)

    # we're parsing a three level hash, first wraps the whole library,
    # second all tracks, the third wraps a single track
    dict_count = 0 # outside all dicts
    tmp_hash = nil
    file.each_line do |l|

      case
        when l.include?('<dict>')
          dict_count +=1
          if dict_count == 3 && tmp_hash.nil? # first row in a new track dict
            tmp_hash = Hash.new
          end
        when l.include?('</dict>')
          dict_count -=1
          if dict_count == 2 && !tmp_hash.nil? # just leaving the single track dict
            @library[track_key(tmp_hash)] = tmp_hash
            tmp_hash = nil
          end
          break if dict_count == 1
        when dict_count == 3 && l.include?('<key>') # in a track dict
          row_hash = rip_hash(l)
          tmp_hash[row_hash[0]] = row_hash[1]
        else
      end

    end
  end

  def clean_filename(raw_filename)
    URI.unescape(File.basename(raw_filename)).downcase.gsub(/\s+/, "_")
  end

  private

  def track_key(track)
    clean_filename(track[:location]) + '~' + track[:track_id]
  end

  def rip_hash(row)
    # ["", "key", "Play Count", "/key", "", "integer", "10", "/integer"]
    # 2 = key, 6 = value

    l = row.split(/[><]/)
    [l[2].downcase.gsub(/\s+/, "_").to_sym, l[6]]
  end

end
