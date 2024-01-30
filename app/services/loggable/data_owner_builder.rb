module Loggable
  module DataOwnerBuilder

    def build_data_owners
      ap '-- build_data_owners --'
      # ap self.class.relations
      self.class.relations.each do |relation_config|
        if relation_config["data_owner"] 
          ap relation_config
        end
      end

      # @payloads.each do |payload|
      #   # payload.build_data_owner(self)
      # end
    end
  end
end