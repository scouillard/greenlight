# frozen_string_literal: true

FactoryBot.define do
  factory :room_meeting_option do
    room
    meeting_option
    value { ['', '12345'].sample }
  end
end
