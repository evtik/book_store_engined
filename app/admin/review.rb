ActiveAdmin.register Review do
  actions(:index, :show, :update)

  config.batch_actions = false
  config.filters = false

  scope(I18n.t('active_admin.resource.index.all'), :all, default: true)
  tr_key = 'activerecord.attributes.review.state.'
  Review.aasm.states.map(&:name).each do |state|
    scope(I18n.t(tr_key + state.to_s), state)
  end

  index do
    column(t('.review.book')) do |review|
      link_to(review.book.title, admin_book_path(review.book))
    end
    column(t('.review.title')) do |review|
      link_to(markdown_truncate(review.title, length: 30),
              admin_review_path(review))
    end
    column(t('.review.body')) do |review|
      markdown_truncate(review.body, length: 90)
    end
    column(t('.review.date'), :created_at)
    column(t('.review.user')) do |review|
      link_to(review.user.email, admin_user_path(review.user))
    end
    column(t('.review.state')) do |review|
      span(t(tr_key + review.state), class: "status_tag #{review.state}")
    end
    column(t('.actions')) { |review| aasm_events_select(review) }
  end

  show do
    attributes_table do
      row(t('.review.state')) do |review|
        span(t(tr_key + review.state), class: "status_tag #{review.state}")
      end
      row(t('.actions')) { |review| aasm_events_select(review) }
      row(t('activerecord.models.user.one')) do |review|
        link_to(review.user.email, admin_user_path(review.user))
      end
      row(t('activerecord.models.book.one')) do |review|
        link_to(review.book.title, admin_book_path(review.book))
      end
      row(:title) { |review| h4(review.title) }
      row(t('.review.body')) do |review|
        markdown(review.body)
      end
    end
  end

  controller do
    def update
      Review.find(params[:id]).send(params[:event].to_s << '!')
      redirect_to(request.referrer)
    end
  end
end
