# frozen_string_literal: true

<<<<<<< HEAD
# BigBlueButton open source conferencing system - http://www.bigbluebutton.org/.
#
# Copyright (c) 2018 BigBlueButton Inc. and by respective authors (see below).
#
# This program is free software; you can redistribute it and/or modify it under the
# terms of the GNU Lesser General Public License as published by the Free Software
# Foundation; either version 3.0 of the License, or (at your option) any later
# version.
#
# BigBlueButton is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License along
# with BigBlueButton; if not, see <http://www.gnu.org/licenses/>.

require 'bbb_api'

class Room < ApplicationRecord
  include Deleteable

  before_create :setup

  before_destroy :destroy_presentation

  validates :name, length: { in: 2..256 }

  belongs_to :owner, class_name: 'User', foreign_key: :user_id
  has_many :shared_access, dependent: :destroy

  has_one_attached :presentation

  class << self
    include Queries

    def admins_search(string)
      like = like_text
      search_query = "rooms.name #{like} :search OR rooms.uid #{like} :search OR users.email #{like} :search" \
      " OR users.#{created_at_text} #{like} :search"

      search_param = "%#{sanitize_sql_like(string)}%"
      where(search_query, search: search_param)
    end

    def admins_order(column, direction, running_ids)
      # Include the owner of the table
      table = joins(:owner)

      # Rely on manual ordering if trying to sort by status
      return order_by_status(table, running_ids) if column == "status"

      return table.order(Arel.sql("COALESCE(rooms.last_session,rooms.created_at) DESC")) if column == "created_at"

      return table.order(Arel.sql("rooms.#{column} #{direction}")) if table.column_names.include?(column)

      return table.order(Arel.sql("#{column} #{direction}")) if column == "users.name"

      table
    end
  end

  # Determines if a user owns a room.
  def owned_by?(user)
    user_id == user&.id
  end

  def shared_users
    User.where(id: shared_access.pluck(:user_id))
  end

  def shared_with?(user)
    return false if user.nil?
    shared_users.include?(user)
  end

  # Determines the invite path for the room.
  def invite_path
    "#{Rails.configuration.relative_url_root}/#{CGI.escape(uid)}"
  end

  # Notify waiting users that a meeting has started.
  def notify_waiting
    ActionCable.server.broadcast("#{uid}_waiting_channel", action: "started")
  end

  # Return table with the running rooms first
  def self.order_by_status(table, ids)
    return table if ids.blank?

    # Get active rooms first
    active_rooms = table.where(bbb_id: ids)

    # Get other rooms sorted by last session date || created at date (whichever is higher)
    inactive_rooms = table.where.not(bbb_id: ids).order("COALESCE(rooms.last_session,rooms.created_at) DESC")

    active_rooms + inactive_rooms
=======
class Room < ApplicationRecord
  belongs_to :user

  has_many :shared_accesses, dependent: :destroy
  has_many :shared_users, through: :shared_accesses, class_name: 'User'

  has_many :recordings, dependent: :destroy
  has_many :room_meeting_options, dependent: :destroy

  has_one_attached :presentation

  validates :name, presence: true
  validates :friendly_id, presence: true, uniqueness: true
  validates :meeting_id, presence: true, uniqueness: true
  validates :presentation,
            content_type: %i[.doc .docx .ppt .pptx .pdf .xls .xlsx .txt .rtf .odt .ods .odp .odg .odc .odi .jpg .jpeg .png],
            size: { less_than: 30.megabytes }

  validates :name, length: { minimum: 2, maximum: 255 }
  validates :recordings_processing, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  before_validation :set_friendly_id, :set_meeting_id, on: :create
  after_create :create_meeting_options

  attr_accessor :shared, :active, :participants

  scope :with_provider, ->(current_provider) { where(user: { provider: current_provider }) }

  def self.search(input)
    return where('rooms.name ILIKE ?', "%#{input}%") if input

    all
  end

  def self.admin_search(input)
    return where('rooms.name ILIKE :input OR users.name ILIKE :input OR rooms.friendly_id ILIKE :input', input: "%#{input}%") if input

    all
  end

  def anyone_joins_as_moderator?
    MeetingOption.get_setting_value(name: 'glAnyoneJoinAsModerator', room_id: id)&.value == 'true'
  end

  def get_setting(name:)
    room_meeting_options.joins(:meeting_option)
                        .find_by(meeting_option: { name: })
  end

  # Autocreate all meeting options using the default values
  def create_meeting_options
    configs = MeetingOption.get_config_value(name: %w[glViewerAccessCode glModeratorAccessCode], provider: user.provider)
    configs = configs.select { |_k, v| v == 'true' }

    MeetingOption.all.find_each do |option|
      value = configs.key?(option.name) ? SecureRandom.alphanumeric(6).downcase : option.default_value
      RoomMeetingOption.create(room: self, meeting_option: option, value:)
    end
>>>>>>> 5a3eb37130dbeeddf333366e83bfc929424877c8
  end

  private

<<<<<<< HEAD
  # Generates a uid for the room and BigBlueButton.
  def setup
    self.uid = random_room_uid
    self.bbb_id = unique_bbb_id
    self.moderator_pw = RandomPassword.generate(length: 12)
    self.attendee_pw = RandomPassword.generate(length: 12)
  end

  # Generates a fully random room uid.
  def random_room_uid
    # 6 character long random string of chars from a..z and 0..9
    full_chunk = SecureRandom.alphanumeric(9).downcase

    [owner.name_chunk, full_chunk[0..2], full_chunk[3..5], full_chunk[6..8]].join("-")
  end

  # Generates a unique bbb_id based on uuid.
  def unique_bbb_id
    loop do
      bbb_id = SecureRandom.alphanumeric(40).downcase
      break bbb_id unless Room.exists?(bbb_id: bbb_id)
    end
  end

  # Before destroying the room, make sure you also destroy the presentation attached
  def destroy_presentation
    presentation.purge if presentation.attached?
=======
  def set_friendly_id
    id = SecureRandom.alphanumeric(12).downcase.scan(/.../).join('-') # Separate into 3 chunks of 4 chars
    raise if Room.exists?(friendly_id: id) # Ensure uniqueness

    self.friendly_id = id
  rescue StandardError
    retry
  end

  # Create a unique meetingId that will be used to communicate with BigBlueButton
  def set_meeting_id
    id = SecureRandom.alphanumeric(40).downcase
    raise if Room.exists?(meeting_id: id) # Ensure uniqueness

    self.meeting_id = id
  rescue StandardError
    retry
>>>>>>> 5a3eb37130dbeeddf333366e83bfc929424877c8
  end
end
