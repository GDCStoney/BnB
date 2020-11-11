feature 'User able to Edit listing' do
  scenario 'Edit button should not be there if User is not logged on' do
    visit '/'
    expect(page).not_to have_selector(:id, "edit")
  end

  # scenario 'Visible edit button' do
  #   visit '/'
  #   add_bob_to_db
  #   expect(page).to have_selector(:id, "edit")
  # end

  # scenario 'Edit button is clicked' do
  #   visit '/'
  #   add_bob_to_db
  #   click_button "Edit"
  #   expect(page.current_path).to eq '/booking/edit'
  # end
end
