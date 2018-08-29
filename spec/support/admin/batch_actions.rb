module BatchActionsHelpers
  include Capybara::DSL

  def check_batch_all
    check('collection_selection_toggle_all')
  end

  def check_batch_items(*items)
    items.each { |item| check("batch_action_item_#{item}") }
  end

  def click_batch_delete
    click_link(t("#{batch_prefix}button_label"))
    click_link(t("#{batch_prefix}action_label",
                 title: t("#{batch_prefix}labels.destroy")))
    click_button('OK')
  end

  def batch_destroyed_label(count:, rejected: 0, model:)
    if rejected.zero?
      fully_destroyed(count, model)
    else
      partially_destroyed(count, rejected, model)
    end
  end

  private

  def fully_destroyed(count, model)
    prefix = "#{batch_prefix}succesfully_destroyed."
    if count == 1
      t("#{prefix}one", model: model)
    else
      t("#{prefix}other", count: count, plural_model: model)
    end
  end

  def partially_destroyed(count, rejected, model)
    tr_hash = { count: count, plural_model: model }
    prefix = "#{batch_prefix}partially_destroyed."
    if rejected == 1
      t("#{prefix}one", tr_hash)
    else
      t("#{prefix}other", tr_hash.merge(rejected: rejected))
    end
  end
end
