module StubsHelper

  def stub_project
    stub Afterburn::Project,
      id: "12345678",
      name: "Trello Project",
      interval_timestamps: [2.days.ago, 1.day.ago, Date.today]
  end

  def stub_backlog_list
    stub(Afterburn::List,
      role: Afterburn::List::Role::BACKLOG,
      name: "backlog",
      :timestamp_count_vector => Vector[1, 2, 3])
  end

  def stub_wip_list
    stub(Afterburn::List,
      role: Afterburn::List::Role::WIP,
      name: "wip",
      :timestamp_count_vector => Vector[1, 2, 3])
  end

  def stub_completed_list
    stub(Afterburn::List, role:
      Afterburn::List::Role::COMPLETED,
      name: "completed",
      :timestamp_count_vector => Vector[1, 2, 3])
  end

end

RSpec.configuration.send(:include, StubsHelper)