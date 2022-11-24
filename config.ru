# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

<<<<<<< HEAD
map Greenlight::Application.config.relative_url_root || "/" do
  run Rails.application
end
=======
run Rails.application
Rails.application.load_server
>>>>>>> 5a3eb37130dbeeddf333366e83bfc929424877c8
