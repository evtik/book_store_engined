shared_examples 'active admin filters' do |params|
  filters = params[:filters]
  filters.each do |filter|
    scenario "click on #{filter} filters out other #{params[:entity]}" do
      first('.table_tools_button', text: t("#{aa_prefix}#{filter}")).click
      (filters - [filter]).each do |state|
        expect(page).not_to have_text(t("#{ar_prefix}#{state}").upcase)
      end
    end
  end
end
