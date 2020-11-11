feature 'user is able to sign_in' do
  scenario 'sign_in on homepage' do
    expect(page).not_to have_selector(:id, 'signed_in')
    add_bob_to_db
    click_button('Signed in')

    visit '/'
    fill_in('username', with: 'Ol Bob')
    fill_in('password', with: 'damnImfine')
    click_button('Sign In')

    expect(page).to have_selector(:id, 'signed_in')

  end
end
