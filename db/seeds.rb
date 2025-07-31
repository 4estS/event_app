events = [
  [ "Team Planning", "Monthly planning and retrospective." ],
  [ "Client Kickoff", "Initial meeting with client stakeholders." ],
  [ "Design Review", "Review of UI/UX progress with design team." ],
  [ "Marketing Sync", "Weekly sync with marketing leads." ],
  [ "Dev Sprint Start", "Sprint planning and task estimation." ],
  [ "QA Walkthrough", "Testing session before release." ],
  [ "Launch Day Prep", "Checklist review and go-live tasks." ],
  [ "Product Demo", "Internal demo of new product features." ],
  [ "Hiring Panel", "Interview panel for engineering candidates." ],
  [ "Postmortem", "Root cause analysis after incident." ]
]

events.each_with_index do |(title, description), i|
  Event.create!(
    user_id: 1,
    category_id: rand(2..7),
    title: title,
    description: description,
    starts_at: Time.current + (i + 1).days,
    ends_at: Time.current + (i + 1).days + 90.minutes
  )
end
