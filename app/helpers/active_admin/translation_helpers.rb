module ActiveAdmin
  module TranslationHelpers
    def aa_tr(resource, action)
      t("active_admin.#{resource.to_s.pluralize}.#{action}.#{action}d_message")
    end
  end
end
