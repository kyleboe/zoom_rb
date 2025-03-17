# frozen_string_literal: true

module Zoom
  module Actions
    module Groups
      extend Zoom::Actions

      get 'groups_list', '/groups'

      get 'groups_get', '/groups/:group_id'

      post 'group_create', '/groups',
        permit: :name

      patch 'group_update', '/groups/:group_id',
        permit: :name

      post 'group_member_create', '/groups/:group_id/members',
        require: :members

      delete 'group_member_delete', '/groups/:group_id/members/:member_id'
    end
  end
end
