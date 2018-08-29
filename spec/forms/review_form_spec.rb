describe ReviewForm, type: :form do
  context 'title' do
    include_examples 'title'
  end

  context 'body' do
    include_examples 'description', :body
  end
end
