require "test_helper"

class ProfileFlowTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test "can update user's own profile" do
    get edit_profile_path
    assert_response :success

    patch profile_path(profiles(:profile_user_two)), 
          params: { profile: { first_name: 'FirstOne', last_name: 'LastOne' } }
    assert_select '.error', /You don't have permission to edit that profile\./

    patch profile_path(profiles(:profile_user_one)),
          params: { profile: { first_name: '', last_name: 'LastOneUpdated' } }
    assert_response :unprocessable_entity
    assert_select '.error', "First name can't be blank"

    patch profile_path(profiles(:profile_user_one)),
          params: {
            profile: {
              first_name: 'FirstOneUpdated', middle_name: '', last_name: 'LastOneUpdated',
              avatar_attributes: {
                id: images(:avatar_user_one).id,
                stored: fixture_file_upload('koi-fish.png', 'image/png')
              }
            }
          }
    assert_response :redirect
    follow_redirect!
    assert_equal('Successfully edited profile.', flash[:notice])

    assert_response :success
    assert_select '.full-name', 'FirstOneUpdated LastOneUpdated'
  end

  test "can update privacy settings on user's profile" do
    get current_user_path
    assert_select 'div.birthdate', count: 0
    assert_select 'div.location', count: 0

    patch profile_path(profiles(:profile_user_one)),
          params: { profile: { birthdate_public: '1', location_public: '1' } }

    get current_user_path
    assert_select 'div.birthdate', 'Birthday: August 23, 1990'
    assert_select 'div.location', 'Location: One, Wisconsin'

    patch profile_path(profiles(:profile_user_one)),
          params: { profile: { birthdate_public: '0', location_public: '0' } }

    get current_user_path
    assert_select 'div.birthdate', count: 0
    assert_select 'div.location', count: 0
  end
end
