ActiveAdmin.register Author do
  permit_params(:first_name, :last_name, :description)

  index do
    selectable_column
    column(:first_name)
    column(:last_name)
    column(:description) { |author| markdown_truncate(author.description) }
    actions
  end

  form do |f|
    f.inputs t('.author.author_details') do
      f.input(:first_name)
      f.input(:last_name)
      f.input(:description, as: :text, input_html: { rows: 5 })
    end
    f.actions
  end

  controller do
    include ActiveAdmin::TranslationHelpers

    def new
      @author = AuthorForm.new
    end

    def create
      @author = AuthorForm.from_params(params)
      return render('new') if @author.invalid?
      Author.create(@author.attributes)
      flash.notice = aa_tr(:author, :create)
      redirect_to(collection_path)
    end

    def edit
      @author = AuthorForm.from_model(Author.find(params[:id]))
    end

    def update
      @author = AuthorForm.from_params(params)
      return render('edit') if @author.invalid?
      Author.find(params[:id]).update_attributes(@author.attributes)
      flash.notice = aa_tr(:author, :update)
      redirect_to(resource_path)
    end
  end
end
