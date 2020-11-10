feature 'user is able to sign_in' do
  scenario 'sign_in on homepage' do
    expect(page).not_to have_selector(:id, 'signed_in')
    visit '/'
    fill_in('username', with: 'Name')
    fill_in('password', with: "Password")
    click_button('submit')

    expect(page).to have_selector(:id, 'signed_in')
    
  end
end
