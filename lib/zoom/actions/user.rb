# frozen_string_literal: true

module Zoom
  module Actions
    module User
      def user_list(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.permit(%i[status page_size page_number])
        response = self.class.get('/users', query: params, headers: request_headers)
        Utils.parse_response(response)
      end

      def user_create(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        require_param_keys = %i[action email type]
        require_param_keys.append(:password) if params[:action] == 'autoCreate'
        params.require(require_param_keys)
        params.permit_value(:action, Zoom::Constants::User::CREATE_TYPES.keys)
        Utils.parse_response self.class.post('/users', body: { action: params[:action], user_info: params.except(:action) }.to_json, headers: request_headers)
      end

      def user_get(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:id).permit(:login_type)
        Utils.parse_response self.class.get("/users/#{params[:id]}", query: params.except(:id), headers: request_headers)
      end

      def user_update(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:id).permit(%i[first_name last_name type pmi timezone dept vanity_name host_key cms_user_id])
        Utils.parse_response self.class.patch("/users/#{params[:id]}", body: params.except(:id), headers: request_headers)
      end

      def user_delete(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:id).permit(%i[action transfer_email transfer_meeting transfer_webinar transfer_recording])
        Utils.parse_response self.class.delete("/users/#{params[:id]}", query: params.except(:id), headers: request_headers)
      end

      def user_assistants_list(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:user_id)
        Utils.parse_response(self.class.get("/users/#{params[:user_id]}/assistants", query: params.except(:user_id), headers: request_headers))
      end

      def user_assistants_create(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:user_id).permit(:assistants)
        Utils.parse_response self.class.post("/users/#{params[:user_id]}/assistants", body: params.except(:user_id), headers: request_headers)
      end

      def user_assistants_delete_all(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:user_id)
        Utils.parse_response(self.class.delete("/users/#{params[:user_id]}/assistants", query: params.except(:user_id), headers: request_headers))
      end

      def user_assistants_delete(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(%i[user_id assistant_id])
        Utils.parse_response(self.class.delete("/users/#{params[:user_id]}/assistants/#{params[:assistant_id]}", query: params.except(:user_id, :assistant_id), headers: request_headers))
      end

      def user_schedulers_list(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:user_id)
        Utils.parse_response(self.class.get("/users/#{params[:user_id]}/schedulers", query: params.except(:user_id), headers: request_headers))
      end

      def user_schedulers_delete_all(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:user_id)
        Utils.parse_response(self.class.delete("/users/#{params[:user_id]}/schedulers", query: params.except(:user_id), headers: request_headers))
      end

      def user_schedulers_delete(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(%i[user_id scheduler_id])
        Utils.parse_response(self.class.delete("/users/#{params[:user_id]}/schedulers/#{params[:scheduler_id]}", query: params.except(:user_id, :scheduler_id), headers: request_headers))
      end

      def user_settings_get(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:id).permit(:login_type)
        Utils.parse_response self.class.get("/users/#{params[:id]}/settings", query: params.except(:id), headers: request_headers)
      end

      def user_email_check(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:email)
        Utils.parse_response(self.class.get('/users/email', query: params.slice(:email), headers: request_headers))
      end

      def user_recordings_list(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:id).permit(%i[page_size next_page_token mc trash from to trash_type])
        Utils.parse_response self.class.get("/users/#{params[:id]}/recordings", query: params.except(:id), headers: request_headers)
      end

      def user_token(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:id)
        Utils.parse_response self.class.get("/users/#{params[:id]}/token", headers: request_headers)
      end
    end
  end
end
