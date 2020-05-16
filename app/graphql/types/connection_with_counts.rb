module Types
  class ConnectionWithCounts < GraphQL::Types::Relay::BaseConnection
    field :total_count, Integer, null: false

    def total_count
      object.nodes.size
    end
  end
end
