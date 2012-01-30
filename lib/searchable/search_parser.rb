
class TableSearchParser

  def initialize(table_model, parent)
    @parent = parent
    @model = table_model
  end

  def table_name
    @model.to_s.pluralize.downcase
  end

  def where(tags)
    model = @model.dup
    tags.each do |k,v|
      # n_eq/foo
      col_abbr, matcher_abbr = k.split('_')
      model = model.where("#{column(col_abbr)} #{@parent.matcher(matcher_abbr)} ?", v)
    end

    model
  end

  def column(abbr)
    "#{table_name}.#{@model.searchable_columns[abbr]}"
  end
end

class SearchParser

  def initialize(class_list = nil)
    @matchers = {eq: '=', lk: 'LIKE', gt: '>', lt: '<'}
    @ar_classes = class_list || get_searchable_classes
    map_classes
  end

  def table(table_abbr)
    TableSearchParser.new(model(table_abbr), self)
  end

  def matcher(abbr)
    @matchers[abbr.to_sym]
  end

  def model(abbr)
    @class_map[abbr.to_sym].first
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