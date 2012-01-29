module SearchableExtentions
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def searchable_as(abbr = nil)
      @abbr = abbr if !abbr.nil?

      @abbr
    end  end
end
# include the extension
ActiveRecord::Base.send(:include, SearchableExtentions)