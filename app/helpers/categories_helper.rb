module CategoriesHelper
  def category_badge(category)
    return unless category

    content_tag :div, category.name,
      class: "#{category.color} inline-block rounded-full px-2 py-1 text-sm font-medium",
      style: "background-color: #{category.color};"
  end
end
