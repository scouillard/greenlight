# frozen_string_literal: true

class Room < ApplicationRecord
  belongs_to :user

  has_many :shared_accesses, dependent: :destroy
  has_many :shared_users, through: :shared_accesses, class_name: 'User'

  has_many :recordings, dependent: :destroy
  has_many :room_meeting_options, dependent: :destroy

  validates :name, presence: true
  validates :friendly_id, presence: true, uniqueness: true
  validates :meeting_id, presence: true, uniqueness: true

  before_validation :set_friendly_id, :set_meeting_id, on: :create
  after_create :set_meeting_passwords!

  def owned_by?(user)
    user_id = user&.id
  end

  def shared_user
  end

  private

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
  end

  # Fetches and create all saved meeting options for the room
  def create_default_meeting_options!(ignore_option_ids)
    meeting_option_ids_default_values_hash = MeetingOption.pluck(:id, :default_value).to_h

    meeting_option_ids_default_values_hash.each_key do |id|
      next if ignore_option_ids.include?(id)

      RoomMeetingOption.create! room_id: self.id, meeting_option_id: id, value: meeting_option_ids_default_values_hash[id]
    end
  end

  # Generates and sets the 'attendeePW' and the 'moderatorPW' for the room meeting
  def set_meeting_passwords!
    password_option_ids = MeetingOption.where('name LIKE ?', '%PW').pluck(:id)

    password_option_ids.each do |id|
      # TODO: Revisit the password random value.
      RoomMeetingOption.create! room_id: self.id, meeting_option_id: id, value: SecureRandom.alphanumeric(20)
    end

    # After creating the passwords, the room can create all other default meeting options
    create_default_meeting_options! password_option_ids
  end
end
