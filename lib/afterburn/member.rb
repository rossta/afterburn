module Afterburn
  class Member < TrelloObjectWrapper
    wrap :member

    set :member_id_set, :global => true

    %w[trello_user_key trello_user_secret trello_app_token].each do |trello_key|
      value "#{trello_key}_value"

      define_method(trello_key) do
        send("#{trello_key}_value").value
      end

      define_method("#{trello_key}=") do |value|
        send("#{trello_key}_value").value = value
      end
    end

    def self.ids
      member_id_set.members
    end

    def self.all
      ids.map { |id| Member.find(id) }
    end

    def self.first
      Member.find(ids.first)
    end

    def self.add_member(member)
      member_id_set << member.id
    end

    def boards
      trello_member.boards.map { |trello_board| Board.initialize_from_trello_object(trello_board) }
    end

# export TRELLO_USER_KEY=3dca2797d175d70a1252cb502a5e49b9
# export TRELLO_USER_SECRET=1532c3edcd355ec3bd7767ab0ac4da190351bed6174358139d284f3d67d978df
# export TRELLO_APP_TOKEN=3aab0899ba564f58c610ce326fbdd3375a206831e7ba68dc95ef3319e90e8170
  end
end