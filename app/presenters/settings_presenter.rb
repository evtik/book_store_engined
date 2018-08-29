class SettingsPresenter < Rectify::Presenter
  %i(billing shipping).each do |address|
    define_method("tr_#{address}") do
      t("ecomm.checkout.address.#{address}_address")
    end
  end
end
