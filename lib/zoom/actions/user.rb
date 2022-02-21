# frozen_string_literal: true

module Zoom
  module Actions
    module User
      extend Zoom::Actions

      get 'user_list', '/users',
        permit: %i[status page_size role_id page_number include_fields next_page_token]

      post 'user_create', '/users',
        require: [
          :action,
          user_info: %i[email type]
        ],
        permit: {
          user_info: %i[first_name last_name password]
        }

      get 'user_get', '/users/:id',
        permit: :login_type

      patch 'user_update', '/users/:id',
        permit: %i[first_name last_name type pmi timezone dept vanity_name host_key cms_user_id]

      delete 'user_delete', '/users/:id',
        permit: %i[action transfer_email transfer_meeting transfer_webinar transfer_recording]

      get 'user_assistants_list', '/users/:user_id/assistants'

      post 'user_assistants_create', '/users/:user_id/assistants',
        permit: :assistants

      delete 'user_assistants_delete_all', '/users/:user_id/assistants'

      delete 'user_assistants_delete', '/users/:user_id/assistants/:assistant_id'

      get 'user_schedulers_list', '/users/:user_id/schedulers'

      delete 'user_schedulers_delete_all', '/users/:user_id/schedulers'

      delete 'user_schedulers_delete', '/users/:user_id/schedulers/:scheduler_id'

      get 'user_settings_get', '/users/:id/settings',
        permit: [:login_type, :option, :custom_query_fields]

      patch 'user_settings_update', '/users/:id/settings',
        permit: %i[schedule_meeting in_meeting email_notification recording telephony feature tsp]

      get 'user_email_check', '/users/email',
        require: :email

      get 'user_recordings_list', '/users/:id/recordings',
        permit: %i[page_size next_page_token mc trash from to trash_type]

      get 'user_token', '/users/:user_id/token',
        permit: %i[type ttl]

      get 'user_permissions', '/users/:user_id/permissions'

      get 'user_vanity_name', '/users/vanity_name',
        require: :vanity_name

      patch 'user_password_update', '/users/:id/password',
        permit: :password

      patch 'user_email_update', '/users/:id/email',
        permit: :email

      patch 'user_status_update', '/users/:id/status',
        permit: :status
    end
  end
end
