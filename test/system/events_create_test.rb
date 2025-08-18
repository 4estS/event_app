# test/system/events_create_test.rb
require "application_system_test_case"

class EventsCreateTest < ApplicationSystemTestCase
  def setup
    @user = users(:one)
    @category = categories(:one)
  end

  test "user creates a Draft event" do
    sign_in_as(@user)
    visit new_event_path

    fill_event_form(
      title: "Community Picnic",
      description: "Bring a dish to share!",
      location_name: "Central Park",
      location: "Central Park, Springfield, IL",
      starts_on: Date.current,
      starts_at: "10:00",
      ends_at: "12:00",
      category_name: @category.name
    )

    assert_difference -> { Event.count }, +1 do
      click_on "Save as Draft"
    end

    event = Event.find_by!(title: "Community Picnic")
    assert_equal "draft", event.status
    assert_equal @user.id, event.user_id
    assert_equal @category.id, event.category_id

    # Assert on a page that definitely lists it
    visit event_path(event)
    assert_text "Community Picnic"
  end

  test "user creates a Published event" do
    sign_in_as(@user)
    visit new_event_path

    fill_event_form(
      title: "Concert in the Park",                # ← fixed title
      description: "Live music and food trucks.",
      location_name: "Riverside Stage",
      location: "200 River Rd, Springfield, IL",
      starts_on: Date.current + 1,
      starts_at: "18:00",
      ends_at: "21:30",
      category_name: @category.name
    )

    assert_difference -> { Event.count }, +1 do
      click_on "Publish"
    end

    event = Event.find_by!(title: "Concert in the Park")
    assert_equal "published", event.status
    visit event_path(event)
    assert_text "Concert in the Park"
  end

  test "validation errors prevent creation" do
    sign_in_as(@user)
    visit new_event_path

    # Intentionally omit required Title/Description
    fill_in "Start Date", with: Date.current.strftime("%Y-%m-%d")
    fill_in "Start Time", with: "09:00"
    fill_in "End Time", with: "10:00"
    select @category.name, from: "Category"

    assert_no_difference -> { Event.count } do
      click_on "Save as Draft"
    end

    # Failed create renders :new; path remains /events (POST to /events)
    assert_current_path events_path
    assert_selector "input[type=submit][value='Save as Draft']"
  end

  test "ticket-required event saves ticket_url" do
    sign_in_as(@user)
    visit new_event_path

    fill_event_form(
      title: "Gala",
      description: "Annual fundraiser.",
      location_name: "Grand Hotel",
      location: "1 Grand Ave, Springfield, IL",
      starts_on: Date.current + 14,
      starts_at: "19:00",
      ends_at: "23:00",
      category_name: @category.name,
      event_type: :ticket_required,                          # handled in helper
      ticket_url: "https://tickets.example.com/gala-2025"    # hidden field handled in helper
    )

    assert_difference -> { Event.count }, +1 do
      click_on "Publish"
    end

    event = Event.find_by!(title: "Gala")
    assert_equal "published", event.status
    assert_equal "ticket_required", event.event_type
    assert_equal "https://tickets.example.com/gala-2025", event.ticket_url
    visit event_path(event)
    assert_text "Gala"
  end
end
