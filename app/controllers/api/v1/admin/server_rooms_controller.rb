# frozen_string_literal: true

module Api
  module V1
    module Admin
      class ServerRoomsController < ApiController
        before_action :find_server_room, only: :destroy

        # GET /api/v1/admin/server_rooms.json
        def index
          rooms = Room.includes(:user).search(params[:search])
          active_rooms = BigBlueButtonApi.new.active_meetings
          active_rooms_ids = []
          participants = []

          active_rooms.each do |active_room|
            active_rooms_ids << active_room[:meetingID]
            participants << active_room[:participantCount]
          end

          rooms.each do |room|
            room.status = (active_rooms_ids.include?(room.meeting_id) ? 'Active' : 'Not Running')
            room.participants = participants[active_rooms_ids.find_index(room.meeting_id)] if room.status == 'Active'
          end

          render_data data: rooms, each_serializer: ServerRoomSerializer
        end

        # DELETE /api/v1/admin/server_rooms/:friendly_id
        # Expects: {}
        # Returns: { data: Array[serializable objects] , errors: Array[String] }
        # Does: Deletes the given server room.
        def destroy
          @server_room.destroy!
          render_json
        end

        private

        def find_server_room
          @server_room = Room.find_by!(friendly_id: params[:friendly_id])
        end
      end
    end
  end
end
