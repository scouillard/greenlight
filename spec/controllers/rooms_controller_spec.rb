# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::RoomsController, type: :controller do
  let(:user) { create(:user) }

  before do
    request.headers['ACCEPT'] = 'application/json'
    session[:user_id] = user.id
  end

  describe '#index' do
    it 'ids of rooms in response are matching room ids that belong to current_user' do
      rooms = create_list(:room, 5, user:)
      get :index
      expect(response).to have_http_status(:ok)
      response_room_ids = JSON.parse(response.body)['data'].map { |room| room['id'] }
      expect(response_room_ids).to eq(rooms.pluck(:id))
    end

    it 'no rooms for current_user should return empty list' do
      get :index
      expect(response).to have_http_status(:ok)
      response_room_ids = JSON.parse(response.body)['data'].map { |room| room['id'] }
      expect(response_room_ids).to be_empty
    end
  end

  describe '#show' do
    it 'returns a room if the friendly id is valid' do
      room = create(:room, user:)
      get :show, params: { friendly_id: room.friendly_id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['data']['id']).to eq(room.id)
    end

    it 'returns :not_found if the room doesnt exist' do
      get :show, params: { friendly_id: 'invalid_friendly_id' }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['data']).to be_empty
    end
  end

  describe '#destroy' do
    it 'deletes room from the database' do
      room = create(:room, user:)
      expect { delete :destroy, params: { friendly_id: room.friendly_id } }.to change(Room, :count).by(-1)
    end

    it 'deletes the recordings associated with the room' do
      room = create(:room, user:)
      create_list(:recording, 10, room:)
      expect { delete :destroy, params: { friendly_id: room.friendly_id } }.to change(Recording, :count).by(-10)
    end
  end

  describe '#start_meeting' do
    let(:join_url) { 'https://test.com/bigbluebutton/api?join' }
    let(:bbb_service) { instance_double(BigBlueButtonApi) }

    before do
      allow(BigBlueButtonApi).to receive(:new).and_return(bbb_service)
      allow(bbb_service).to receive(:start_meeting).and_return(join_url)
    end

    it 'returns the join_url for existent room' do
      room = create(:room, user:)
      post :start, params: { friendly_id: room.friendly_id }
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['data']['join_url']).to eq(join_url)
    end

    it 'returns :not_found if the room doesn\'t exist' do
      post :start, params: { friendly_id: 'invalid_friendly_id' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe '#create' do
    let(:room_params) do
      {
        room: { name: Faker::Science.science }
      }
    end

    it 'creates a room for the authenticated user' do
      session[:user_id] = user.id
      expect { post :create, params: room_params }.to change { user.rooms.count }.from(0).to(1)
      expect(response).to have_http_status(:created)
    end
  end

  describe '#recordings' do
    it 'returns recordings belonging to the room' do
      room1 = create(:room, user:, friendly_id: 'friendly_id_1')
      room2 = create(:room, user:, friendly_id: 'friendly_id_2')
      recordings = create_list(:recording, 5, room: room1)
      create_list(:recording, 5, room: room2)
      get :recordings, params: { friendly_id: room1.friendly_id }
      recording_ids = JSON.parse(response.body)['data'].map { |recording| recording['id'] }
      expect(response).to have_http_status(:ok)
      expect(recording_ids).to eq(recordings.pluck(:id))
    end

    it 'returns an empty array if the room has no recordings' do
      room1 = create(:room, user:, friendly_id: 'friendly_id_1')
      get :recordings, params: { friendly_id: room1.friendly_id }
      recording_ids = JSON.parse(response.body)['data'].map { |recording| recording['id'] }
      expect(response).to have_http_status(:ok)
      expect(recording_ids).to be_empty
    end
  end

  describe '#share_room_access' do
    it 'shares a room with a user' do
      room = create(:room)
      post :share_room_access, params: { friendly_id: room.friendly_id, shared_access_users: [user.id] }
      expect(user.shared_rooms).to include(room)
    end

    it "doesn't share a room with a user that it not selected" do
      room = create(:room)
      random_user = create(:user)
      post :share_room_access, params: { friendly_id: room.friendly_id, shared_access_users: [random_user.id] }
      expect(user.shared_rooms).not_to include(room)
    end

    it "cannot share the room to the room's owner" do
      room = create(:room, user:)
      post :share_room_access, params: { friendly_id: room.friendly_id, shared_access_users: [user.id] }
      expect(user.shared_rooms).not_to include(room)
    end
  end

  describe '#unshare_room_access' do
    it 'unshares a room with a user' do
      room = create(:room)
      create(:shared_access, user_id: user.id, room_id: room.id)
      delete :unshare_room_access, params: { friendly_id: room.friendly_id, user_id: user.id, room_id: room.id}
      expect(user.shared_rooms).not_to include(room)
    end

    it "doesn't unshare a room with a user that is not selected" do
      room = create(:room)
      random_user = create(:user)
      create(:shared_access, user_id: user.id, room_id: room.id)
      create(:shared_access, user_id: random_user.id, room_id: room.id)
      delete :unshare_room_access, params: { friendly_id: room.friendly_id, user_id: random_user.id, room_id: room.id}
      expect(user.shared_rooms).to include(room)
    end
  end

  describe '#shared_users' do
    it 'lists the users that the room has been shared to' do
      room = create(:room)
      users = create_list(:user, 10)
      shared_users = []

      users[0..4].each do |user|
        create(:shared_access, user_id: user.id, room_id: room.id)
        shared_users << user
      end

      get :shared_users, params: { friendly_id: room.friendly_id }
      shared_user_response = JSON.parse(response.body)['data'].map { |user| user['id'] }
      expect(shared_user_response).to eql(shared_users.pluck(:id))
    end
  end

  describe '#shareable_users' do
    it 'lists the users that the room can be shared to' do
      room = create(:room)
      users = create_list(:user, 10)
      shared_users = []
      shareable_users = []

      users[0..4].each do |user|
        create(:shared_access, user_id: user.id, room_id: room.id)
        shared_users << user
      end

      users[5..9].each do |user|
        shareable_users << user
      end

      get :shareable_users, params: { friendly_id: room.friendly_id }
      shareable_user_response = JSON.parse(response.body)['data'].map { |user| user['id'] }
      expect(shareable_user_response).to eql(shareable_users.pluck(:id))
    end
  end
end
