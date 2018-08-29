ActiveAdmin.register User do
  permit_params(:email, :password, :password_confirmation, :admin)

  index do
    selectable_column
    column(:email)
    column(:admin)
    actions
  end

  filter(:email)

  form do |f|
    f.inputs(t('.user.user_details')) do
      f.input(:email)
      f.input(:password)
      f.input(:password_confirmation)
      f.input(:admin, as: :boolean)
    end
    f.actions
  end
end
