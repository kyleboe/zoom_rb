# frozen_string_literal: true

module Zoom
  module Actions
    module SipAudio
      extend Zoom::Actions

      get 'sip_trunks_get', '/accounts/:account_id/sip_trunk/trunks'

      delete 'sip_trunks_delete', '/accounts/:account_id/sip_trunk/trunks/:trunk_id'

      delete 'sip_trunk_numbers_delete', '/accounts/:account_id/sip_trunk/numbers'

      delete 'sip_trunks_internal_numbers_delete',
        '/accounts/:account_id/sip_trunk/internal_numbers/:number_id'

      delete 'sip_trunks_internal_callout_country_delete',
        '/accounts/:account_id/sip_trunk/callout_countries/:country_id'

      get 'sip_trunks_internal_numbers_list', '/accounts/:account_id/sip_trunk/internal_numbers',
        permit: %i[page_size next_page_token]

      get 'sip_trunks_internal_callout_country_list', '/accounts/:account_id/sip_trunk/callout_countries'

      get 'sip_trunks_numbers_list', '/sip_trunk/numbers'

      post 'sip_trunks_internal_numbers_add', '/accounts/:account_id/sip_trunk/internal_numbers'

      post 'sip_trunks_internal_callout_countries_add', '/accounts/:account_id/sip_trunk/callout_countries'

      post 'sip_trunks_numbers_assign', '/accounts/:account_id/sip_trunk/numbers'
    end
  end
end
