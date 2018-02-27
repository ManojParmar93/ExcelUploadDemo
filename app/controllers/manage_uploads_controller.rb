class ManageUploadsController < ApplicationController
  before_action :set_users, only: :display_records

  def index
  end

  def upload_file_and_manage_users
    User.reject_if_unknown_file(files_from_params)
    User.create_from_file(files_from_params)
    redirected_to root_path
  rescue => exception
    flash[:notice] = exception.message
    render :index
  end

  def display_records
  end

  private

  def set_users
    @users = User.all
  end

  def files_from_params
    params.require(:excel_files)
  end
end
