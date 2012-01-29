
class SearchParser


  def initialize(class_list = nil)
    @ar_classes = class_list || get_searchable_classes
    map_classes
  end


  def parse_tag
    ''
  end

  def model_for(abbr)
    @class_map[abbr.to_sym].first
  end

  def table_name_for(abbr)
    model_for(abbr).to_s.pluralize.downcase
  end

  private

  def map_classes
    @class_map = @ar_classes.group_by { |c| c.searchable_as }
  end

  def get_searchable_classes
    ar_classes = Dir['app/models/*.rb'].map {|f| File.basename(f, '.*').camelize.constantize }
    ar_classes.select { |c| !c.searchable_as.nil? }
  end


end