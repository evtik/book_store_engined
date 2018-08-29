module ApplicationHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def cart_items_count
    return session[:cart].length if session[:cart]
    0
  end

  def capitalize_category(name)
    name.split.map(&:capitalize).join(' ')
  end

  def markdown(text)
    renderer = Redcarpet::Render::HTML.new
    Redcarpet::Markdown.new(renderer).render(text).html_safe
  end

  def markdown_truncate(text, options = {})
    length = options[:length] || 60
    truncate(markdown(text), length: length, escape: false)
  end
end
