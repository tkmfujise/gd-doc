module Helper
  def header_title
    @config[:title] || @items['/index.*']&.[](:application_name) || 'gd-doc'
  end
end

