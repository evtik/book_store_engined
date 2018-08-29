module Settings
  class FindOrInitializeAddress < Ecomm::BaseService
    def call(attributes, user_id)
      Ecomm::Address.find_or_initialize_by(id: attributes[:id]).tap do |address|
        address.attributes = attributes
        address.customer_id ||= user_id
      end
    end
  end
end
