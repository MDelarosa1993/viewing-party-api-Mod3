class AddUniqueIndexToViewingPartyName < ActiveRecord::Migration[7.1]
  def change
    add_index :viewing_parties, :name, unique: true
  end
end
