class AddAbbrevToMeasurements < ActiveRecord::Migration[5.2]
  def change
    add_column :measurements, :abbrev, :string
  end
end
