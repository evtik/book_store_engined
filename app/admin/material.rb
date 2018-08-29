ActiveAdmin.register Material do
  permit_params(:name)

  index do
    selectable_column
    column(:name)
    actions
  end

  form do |f|
    f.inputs(t('.material.material_details')) do
      f.input(:name)
    end
    f.actions
  end

  controller do
    include ActiveAdmin::TranslationHelpers

    def new
      @material = MaterialForm.new
    end

    def create
      @material = MaterialForm.from_params(params)
      return render('new') if @material.invalid?
      Material.create(@material.attributes)
      flash.notice = aa_tr(:material, :create)
      redirect_to(collection_path)
    end

    def edit
      @material = MaterialForm.from_model(Material.find(params[:id]))
    end

    def update
      @material = MaterialForm.from_params(params)
      return render('edit') if @material.invalid?
      Material.find(params[:id]).update_attributes(@material.attributes)
      flash.notice = aa_tr(:material, :update)
      redirect_to(resource_path)
    end
  end
end
