# frozen_string_literal: true

module Zoom
  module Actions
    module Recording
      def recording_list(*args)
        options = Utils.extract_options!(args)
        Utils.require_params([:host_id], options)
        Utils.process_datetime_params!(%i[from to], options)
        Utils.parse_response self.class.post('/recording/list', query: options)
      end

      def mc_recording_list(*args)
        options = Utils.extract_options!(args)
        Utils.require_params([:host_id], options)
        Utils.process_datetime_params!(%i[from to], options)
        Utils.parse_response self.class.post('/mc/recording/list', query: options)
      end

      def recording_get(*args)
        options = Utils.extract_options!(args)
        Utils.require_params([:meeting_id], options)
        Utils.parse_response self.class.get("/meetings/#{options[:meeting_id]}/recordings", headers: request_headers)
      end

      def recording_delete(*args)
        options = Utils.extract_options!(args)
        Utils.require_params([:meeting_id], options)
        Utils.parse_response self.class.delete("/meetings/#{options[:meeting_id]}/recordings",  query: options.except(:meeting_id), headers: request_headers)
      end

      def recording_delete_file(*args)
        options = Utils.extract_options!(args)
        Utils.require_params([:meeting_id], options)
        Utils.require_params([:recording_id], options)
        Utils.parse_response self.class.delete("/meetings/#{options[:meeting_id]}/recordings/#{options[:recording_id]}",  query: options.except(:meeting_id).excpet(:recording_id), headers: request_headers)
      end

    end
  end
end
