class ProfilesController < ApplicationController
  def edit
    @profile = current_user.profile
  end

  def update
    @profile = Profile.find(params[:id])
    return unauthorized_redirect('edit', @profile.user) unless @profile.user == current_user

    if @profile.update(profile_params)
      flash[:notice] = 'Successfully edited profile.'
      redirect_to @profile.user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:first_name, :middle_name, :last_name,
                                    :birthdate, :location, avatar_attributes: %i[id stored])
  end
end
