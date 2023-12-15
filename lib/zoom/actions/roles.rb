# frozen_string_literal: true

module Zoom
  module Actions
    module Roles
      extend Zoom::Actions

      get 'roles_list', '/roles'

      post 'roles_create', '/roles',
        require: :name,
        permit: %i[description privileges]

      get 'roles_members', '/roles/:role_id/members',
        permit: %i[next_page_token, page_size, page_number]

      post 'roles_assign', '/roles/:role_id/members',
        require: :members

      delete 'roles_unassign', '/roles/:role_id/members/:member_id'

      get 'roles_get', '/roles/:role_id'
    end
  end
end
