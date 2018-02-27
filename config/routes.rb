Rails.application.routes.draw do
  root 'manage_uploads#index'

  get 'manage_uploads/index' 

  get 'manage_uploads/display_records'

  post 'manage_uploads/upload_file_and_manage_users'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
