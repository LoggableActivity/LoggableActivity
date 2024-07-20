# app/services/rabbitmq_publisher.rb

class RabbitmqPublisher
  def self.publish(queue_name, message)
    queue = BUNNY_CHANNEL.queue(queue_name, durable: true)
    queue.publish(message.to_json, persistent: true)
  end
end
