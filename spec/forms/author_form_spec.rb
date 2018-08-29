describe AuthorForm, type: :form do
  context 'first name' do
    include_examples 'name', :first_name
  end

  context 'last name' do
    include_examples 'name', :last_name
  end

  context 'description' do
    include_examples 'description', :description
  end
end
