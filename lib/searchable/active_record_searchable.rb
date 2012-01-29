module SearchableExtentions
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def searchable_as(abbr = nil)
      @searchable_as = abbr if !abbr.nil?
      @searchable_as
    end

    def searchable_columns(hash = nil)
      @searchable_columns = hash if !hash.nil?
      @searchable_columns.invert
    end
  end
end
# include the extension
ActiveRecord::Base.send(:include, SearchableExtentions)