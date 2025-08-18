# test/support/system_helpers.rb
module SystemHelpers
  def sign_in_as(user)
    visit sign_in_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_button "Log in"
    # Accept either landing page
    acceptable = [ dashboard_path, home_path ]
    raise "Unexpected redirect to #{page.current_path}" unless acceptable.include?(page.current_path)
  end

  def fill_event_form(title:, description:, location_name:, location:, starts_on:, starts_at:, ends_at:, category_name:, event_type: nil, ticket_url: nil)
    fill_in "Title", with: title
    fill_in "Description", with: description
    fill_in "Location Name", with: location_name
    find("#event_location", visible: false).set(location)  # hidden field
    fill_in "Start Date", with: starts_on.strftime("%Y-%m-%d")
    fill_in "Start Time", with: starts_at
    fill_in "End Time", with: ends_at
    select category_name, from: "Category"

    choose "event_type_#{event_type}" if event_type
    find("#event_ticket_url", visible: false).set(ticket_url) if ticket_url
  end
end
