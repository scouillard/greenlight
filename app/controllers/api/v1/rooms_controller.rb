# frozen_string_literal: true

module Api
  module V1
    class RoomsController < ApplicationController
      skip_before_action :verify_authenticity_token # TODO: amir - Revisit this.
      before_action :find_room, only: %i[show start recordings share_room_access shared_users shareable_users unshare_room_access]

      # GET /api/v1/rooms.json
      # Returns: { data: Array[serializable objects(rooms)] , errors: Array[String] }
      # Does: Returns the Rooms that belong to the user currently logged in
      def index
        # Return the rooms that belong to current user
        rooms = Room.where(user_id: current_user&.id)

        render_json data: rooms, status: :ok
      end

      def show
        render_json data: @room, status: :ok
      end

      def destroy
        Room.destroy_by(friendly_id: params[:friendly_id])
        render_json status: :ok
      end

      # POST /api/v1/rooms/:friendly_id/start.json
      # Returns: { data: Array[serializable objects] , errors: Array[String] }
      # Does: Starts the Room meeting and joins in the meeting starter.
      def start
        # TODO: amir - Check the legitimately of the action.
        bbb_api = BigBlueButtonApi.new
        meeting_starter = current_user ? "user(id):#{current_user.id}" : 'unauthenticated user'
        options = { logoutURL: request.headers['Referer'] || root_url }
        retries = 0
        begin
          logger.info "Starting meeting for room(friendly_id):#{@room.friendly_id} by #{meeting_starter}."
          join_url = bbb_api.start_meeting room: @room, meeting_starter: current_user, options: options
          logger.info "meeting successfully started for room(friendly_id):#{@room.friendly_id} by #{meeting_starter}."

          render_json data: { join_url: }, status: :created
        rescue BigBlueButton::BigBlueButtonException => e
          retries += 1
          logger.info "Retrying meeting start for room(friendly_id):#{@room.friendly_id} because of error(key): #{e.key} #{retries} times..."
          retry unless retries >= 3
          raise e
        end
      end

      # POST /api/v1/rooms.json
      # Returns: { data: Array[serializable objects] , errors: Array[String] }
      # Does: creates a room for the authenticated user.
      def create
        # TODO: amir - ensure accessibility for unauthenticated requests only.
        room = Room.create!(room_params.merge(user_id: current_user.id))
        logger.info "room(friendly_id):#{room.friendly_id} created for user(id):#{current_user.id}"
        render_json status: :created
      end

      # GET /api/v1/rooms/:friendly_id/recordings.json
      # Returns: { data: Array[serializable objects] , errors: Array[String] }
      # Does: gets the recordings that belong to the specific room friendly_id
      def recordings
        render_json(data: @room.recordings, status: :ok, include: :formats)
      end

      # POST /api/v1/rooms/friendly_id/share_room_access
      def share_room_access
        shared_users = User.where(id: params[:shared_access_users])

        shared_users.each do |shared_user|
          SharedAccess.find_or_create_by!(user_id: shared_user.id, room_id: @room.id)
        end

        render_json status: :ok
      end

      # GET /api/v1/rooms/friendly_id/shared_users.json
      def shared_users
        shared_users = []

        # User is added to the shared_user list if the room is shared to the user and it is not already included in shared_user
        User.joins(:shared_rooms).each do |user|
          shared_users << user if user.room_shared?(@room) && shared_users.exclude?(user)
        end

        shared_users.map! do |user|
          {
            id: user.id,
            name: user.name,
            email: user.email,
            avatar: user_avatar(user)
          }
        end

        render_json data: shared_users, status: :ok
      end

      # GET /api/v1/rooms/friendly_id/shareable_users.json
      def shareable_users
        shareable_users = []

        # User is added to the shareable_user list unless it's the room owner or the room is already shared to the user
        User.all.each do |user|
          shareable_users << user unless user.room_owner?(@room) || user.room_shared?(@room)
        end

        shareable_users.map! do |user|
          {
            id: user.id,
            name: user.name,
            email: user.email,
            avatar: user_avatar(user)
          }
        end

        render_json data: shareable_users, status: :ok
      end

      # DELETE /api/v1/rooms/friendly_id/delete_share_room_access.json
      def unshare_room_access
        room = Room.find_by(friendly_id: params[:friendly_id])
        user = User.find_by(id: params[:user_id])

        SharedAccess.find_by!(user_id: user.id, room_id: room.id).delete

        render_json status: :ok
      end


      private

      def find_room
        @room = Room.find_by!(friendly_id: params[:friendly_id])
      end

      def room_params
        params.require(:room).permit(:name, :user_id)
      end
    end
  end
end
