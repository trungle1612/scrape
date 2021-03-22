class CreateTrackings < ActiveRecord::Migration[6.0]
  def change
    create_table :trackings do |t|
      t.string  :tracking_type
      t.integer :count

      t.timestamps
    end
  end
end
