# frozen_string_literal: true
#
module Zoom
  module Actions
    module Token
      extend Zoom::Actions

      post 'access_tokens',
        '/oauth/token',
        oauth: true,
        require: %i[grant_type code redirect_uri],
        permit: :code_verifier,
        args_to_params: { auth_code: :code }

      post 'access_tokens_account_credentials',
        '/oauth/token?grant_type=account_credentials',
        oauth: true,
        require: :account_id

      post 'refresh_tokens',
        '/oauth/token',
        oauth: true,
        require: %i[grant_type refresh_token]

      post 'data_compliance', '/oauth/data/compliance',
        oauth: true,
        require: %i[
          client_id user_id account_id deauthorization_event_received compliance_completed
        ]

      post 'revoke_tokens', '/oauth/revoke',
        oauth: true,
        require: :token,
        args_to_params: { access_token: :token }
    end
  end
end
