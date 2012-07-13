class CreateAfterburnBoards < ActiveRecord::Migration
  def change
    create_table :afterburn_boards do |t|
      t.string :name
      t.string :trello_id

      t.timestamps
    end
  end
end
