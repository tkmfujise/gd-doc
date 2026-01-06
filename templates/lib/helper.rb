module Helper
  def header_title
    @config[:title] || @items['/index.*']&.[](:application_name) || 'gd-doc'
  end

  def categories
    %w[scenes scripts resources assets]
  end
  
  def current_category
    category_of(@item)
  end

  def category_of(item)
    categories.find{|c| item.path.start_with? "/#{c}" } || categories[0]
  end

  def all_items_of(category)
    @items.find_all("/#{category}/**/*.adoc")
  end

  def siblings_of(item)
    all_items_of(category_of(item))
  end

  def neighbor_items_of(item)
    items = siblings_of(item)
    [prev_item_in(items, item), next_item_in(items, item)]
  end

  def prev_item_in(items, item)
    idx = items.index(item)
    idx && idx > 0 ? items[idx - 1] : nil
  end

  def next_item_in(items, item)
    idx = items.index(item)
    idx ? items[idx + 1] : nil
  end


  def link_text_of(item)
    item.path.delete_prefix("/#{category_of(item)}/")[0..-2]
  end
end

