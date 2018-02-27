class ManageUploadsController < ApplicationController
  before_action :set_users, only: :display_records

  def index
  end

  def upload_file_and_manage_users
    User.reject_if_unknown_file(files_from_params)
    
    User.delay.create_from_file(collect_temp_files)
    redirect_to root_path
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

def collect_temp_files
  files_from_params.collect do |file|
    tmp = file.tempfile
    raise ToLargeFile.new("#{file.original_filename} is too large to handle.") if file.size > 10240000
    destiny_file = File.join('public', 'uploads', file.original_filename)
    FileUtils.move "//#{tmp.path}", destiny_file
    destiny_file
  end
end
end
