module Settings
  class UpdateAddress < Ecomm::BaseCommand
    def self.build
      new(Settings::FindOrInitializeAddress.build,
          Settings::GenerateAddressUpdatedMessage.build)
    end

    def initialize(*args)
      @find_init_address, @updated_message = args
    end

    def call(params, user_id)
      address_type = params.key(t('settings.show.save'))
      address = Ecomm::AddressForm.from_params(params[:address][address_type])
      return publish(:invalid, address) if address.invalid?
      @find_init_address.call(address.to_h, user_id).save
      publish(:ok, @updated_message.call(address_type))
    end
  end
end
