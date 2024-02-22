# frozen_string_literal: true

class MockActivity
  def initialize
    @action = 'default_action'
    @record_display_name = 'Default Record'
    @actor_display_name = 'Default Actor'
    @created_at = Time.now
  end

  attr_reader :action, :record_display_name, :actor_display_name, :created_at
end
