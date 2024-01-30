# frozen_string_literal: true

json.extract! demo_journal, :id, :patient_id, :doctor_id, :title, :body, :state, :created_at, :updated_at
json.url demo_journal_url(demo_journal, format: :json)
