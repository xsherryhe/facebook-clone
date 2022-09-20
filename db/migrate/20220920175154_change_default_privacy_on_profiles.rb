class ChangeDefaultPrivacyOnProfiles < ActiveRecord::Migration[7.0]
  def change
    change_column_default :profiles, :privacy,
                          from: { first_name: :public, middle_name: :public, last_name: :public,
                                  birthdate: :private, location: :private }.to_yaml,
                          to: { 'first_name' => 1, 'middle_name' => 1, 'last_name' => 1,
                                'birthdate' => 0, 'location' => 0 }.to_yaml
  end
end
