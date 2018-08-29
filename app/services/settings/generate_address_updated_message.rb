module Settings
  class GenerateAddressUpdatedMessage < Ecomm::BaseService
    include AbstractController::Translation

    def call(type)
      t('settings.show.address_saved',
        address_type: t("ecomm.checkout.address.#{type}"))
    end
  end
end
