# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
categories = [
  {
    name: "Markets & Food",
    description: "Local markets, food festivals, and culinary experiences.",
    color: "#FFB07A"
  },
  {
    name: "Arts & Entertainment",
    description: "Concerts, theater, galleries, and cultural exhibitions.",
    color: "#B99CE0"
  },
  {
    name: "Social & Nightlife",
    description: "Parties, meetups, and nightlife events.",
    color: "#5FD6FC"
  },
  {
    name: "Charity & Causes",
    description: "Fundraisers, non-profit events, and awareness campaigns.",
    color: "#FF7399"
  },
  {
    name: "Sports & Outdoors",
    description: "Athletic events, hiking, and outdoor activities.",
    color: "#7FE6B8"
  },
  {
    name: "Family & Community",
    description: "Events for families, kids, and neighborhood gatherings.",
    color: "#FFE955"
  }
]

categories.each do |attrs|
  category = Category.find_or_initialize_by(name: attrs[:name])
  category.update!(description: attrs[:description], color: attrs[:color])
end
