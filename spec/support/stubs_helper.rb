module StubsHelper

  def stub_project(attributes = {})
    stub Afterburn::Project, attributes.merge(
      id: "12345678",
      name: "Trello Project",
      interval_timestamps: [2.days.ago, 1.day.ago, Date.today],
      backlog_lists: [stub_backlog_list, stub_backlog_list],
      wip_lists: [stub_wip_list, stub_wip_list],
      completed_lists: [stub_completed_list, stub_completed_list]
    )
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
    stub(Afterburn::List, 
      role: Afterburn::List::Role::COMPLETED,
      name: "completed",
      :timestamp_count_vector => Vector[1, 2, 3])
  end

  def stub_list_interval(attributes = {})
    card_count = attributes[:card_count] || rand(10)
    stub(Afterburn::ListInterval, attributes.merge(
      list: stub_wip_list,
      timestamp: Time.now,
      cart_count: card_count
    ))
  end
    
end

RSpec.configuration.send(:include, StubsHelper)