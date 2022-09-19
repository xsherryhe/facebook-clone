require "test_helper"

class ProfileFlowTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test "can update user's own profile" do
    get edit_profile_path
    assert_response :success

    patch profile_path(profiles(:profile_user_two)), params: { profile: { first_name: 'FirstOne', last_name: 'LastOne' } }
    assert_equal("You don't have permission to edit that profile.", flash[:error])
    assert_response :redirect

    patch profile_path(profiles(:profile_user_one)), params: { profile: { first_name: '', last_name: 'LastOneUpdated' } }
    assert_response :unprocessable_entity
    assert_select 'p.error', "First name can't be blank"

    patch profile_path(profiles(:profile_user_one)),
          params: {
            profile: {
              first_name: 'FirstOneUpdated',
              middle_name: '',
              last_name: 'LastOneUpdated',
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
    assert_select 'h3', 'FirstOneUpdated LastOneUpdated'
  end
end
