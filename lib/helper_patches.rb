class String
  def space_to_underscore
    self.gsub(/\s+/, "_")
  end
end

class Object
  def try_chain(*args)
    args.size > 1 ? eval("self.try(args[0]).try_chain(#{args[1..-1].inspect[1..-2]})") : self.try(args[0])
  end
end