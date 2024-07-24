# frozen_string_literal: true

# config/initializers/bunny.rb

require 'bunny'

# Configuration for Bunny (RabbitMQ client)
BunnyApp = Bunny.new(
  host: 'localhost',
  port: 5672, # default port for RabbitMQ
  vhost: '/',
  user: 'guest', # default user
  password: 'guest' # default password
)

BunnyApp.start

# You can create a channel and default exchange for the application here
BUNNY_CHANNEL = BunnyApp.create_channel
