# frozen_string_literal: true

module Zoom
  module Actions
    module IM
      module Chat
        extend Zoom::Actions

        get 'get_chat_channels', '/chat/channels/:channel_id'

        get 'get_chat_user_channels', '/chat/users/:user_id/channels',
          permit: %i[next_page_token page_size]

        # Get chat messages for a specified period.
        # TODO: implement `next_page_token`, will be returned whenever the set of available chat history list exceeds 100. The expiration period is 30 minutes.
        get 'chat_get', '/chat/get',
          require: [ :access_token, :session_id, :from, :to ]

        # Get chat history list for a specified time period.
        # TODO: implement `next_page_token`, will be returned whenever the set of available chat history list exceeds 100. The expiration period is 30 minutes.
        get 'chat_list', '/chat/list',
          require: [ :access_token, :from, :to ]
      end
    end
  end
end
