module ApplicationHelper

  def datatable_for(columns, options = {})
    content_tag :table, id: options[:id] do
      thead(columns)
    end
  end

  def thead(columns)
    content_tag :thead do
      content_tag :tr do
        columns.each do |c|
          concat(content_tag(:th, c[:name]))
        end
      end
    end
  end

  #def column(name, value = nil, &block)
  #  value = name unless value
  #  @columns << {:name => name, :value => value, :block => block}
  #end


end
