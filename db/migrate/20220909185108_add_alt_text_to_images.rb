class AddAltTextToImages < ActiveRecord::Migration[7.0]
  def change
    add_column :images, :alt_text, :string
  end
end
