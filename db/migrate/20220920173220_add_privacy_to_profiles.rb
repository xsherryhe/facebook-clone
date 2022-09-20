class AddPrivacyToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :privacy, :string,
               default: { first_name: :public, middle_name: :public, last_name: :public,
                          birthdate: :private, location: :private }.to_yaml
  end
end
