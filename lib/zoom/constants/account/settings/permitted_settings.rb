module Zoom
  module Constants
    module Account
      module Settings
        PERMITTED_OPTIONS = %i[meeting_authentication recording_authentication]

        PERMITTED_KEYS = {
          schedule_meeting: %i[
            host_video
            participant_video
            audio_type
            join_before_host
            enforce_login
            enforce_login_with_domains
            enforce_login_domains
            not_store_meeting_topic
            force_pmi_jbh_password
            require_password_for_scheduling_new_meetings
            require_password_for_scheduled_meetings
            require_password_for_instant_meetings
            require_password_for_pmi_meetings
            use_pmi_for_scheduled_meetings
            use_pmi_for_instant_meetings
          ],
          in_meeting: %i[
            e2e_encryption
            chat
            private_chat
            auto_saving_chat
            feedback
            post_meeting_feedback
            co_host
            polling
            attendee_on_hold
            show_meeting_control_toolbar
            allow_show_zoom_windows
            annotation
            whiteboard
            webinar_question_answer
            anonymous_question_answer
            breakout_room
            closed_caption
            far_end_camera_control
            group_hd
            virtual_background
            watermark
            alert_guest_join
            auto_answer
            p2p_connetion
            p2p_ports
            ports_range
            sending_default_email_invites
            use_html_format_email
            dscp_marking
            dscp_audio
            dscp_video
            stereo_audio
            original_audio
            screen_sharing
            remote_control
          ],
          email_notification: %i[
            cloud_recording_avaliable_reminder
            jbh_reminder
            cancel_meeting_reminder
            low_host_count_reminder
            alternative_host_reminder
          ],
          zoom_rooms: %i[
            upcoming_meeting_alert
            start_airplay_manually
            weekly_system_restart
            list_meetings_with_calendar
            zr_post_meeting_feedback
            ultrasonic
            force_private_meeting
            hide_host_information
            cmr_for_instant_meeting
            auto_start_stop_scheduled_meetings
          ],
          security: %i[
            admin_change_name_pic
            import_photos_from_devices
            hide_billing_info
          ],
          recording: %i[
            local_recording
            cloud_recording
            record_speaker_view
            record_gallery_view
            record_audio_file
            save_chat_text
            show_timestamp
            recording_audio_transcript
            auto_recording
            cloud_recording_download
            cloud_recording_download_host
            account_user_access_recording
            auto_delete_cmr
            auto_delete_cmr_days
          ],
          telephony: %i[
            third_party_audio
            audio_conference_info
          ],
          tsp: [
            :call_out,
            :show_international_numbers_link,
            :display_toll_free_numbers,
            {call_out_countries: []}
          ],
          integration: %i[
            google_calendar
            google_drive
            dropbox
            box
            microsoft_one_drive
            kubi
          ],
          feature: :meeting_capacity
        }.freeze
      end
    end
  end
end
