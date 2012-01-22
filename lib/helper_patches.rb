class String
  def space_to_underscore
    self.gsub(/\s+/, "_")
  end

  def sanitize_for_filename()
    name = self.strip
    # NOTE: File.basename doesn't work right with Windows paths on Unix
    # get only the filename, not the whole path
    name.gsub! /^.*(\\|\/)/, ''

    # Finally, replace all non alphanumeric, underscore
    # or periods with underscore
    # name.gsub! /[^\w\.\-]/, '_'
    # Basically strip out the non-ascii alphabets too
    # and replace with x.
    # You don't want all _ :)
    name.gsub!(/[^0-9A-Za-z.\-_]/, '')
    name
  end
end

class Object
  def try_chain(*args)
    args.size > 1 ? eval("self.try(args[0]).try_chain(#{args[1..-1].inspect[1..-2]})") : self.try(args[0])
  end
end