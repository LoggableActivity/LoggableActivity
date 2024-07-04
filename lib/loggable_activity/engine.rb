# frozen_string_literal: true

module LoggableActivity
  class Engine < ::Rails::Engine
    isolate_namespace LoggableActivity
  end
end
