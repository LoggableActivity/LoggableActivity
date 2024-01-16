# frozen_string_literal: true

json.extract! demo_club, :id, :name, :created_at, :updated_at
json.url demo_club_url(demo_club, format: :json)
