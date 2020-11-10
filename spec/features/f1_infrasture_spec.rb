feature 'User is able to access homepage' do
  scenario 'user sees title of application' do
    visit '/'

    expect(page).to have_content "Welcome to the BEST Beaches and Stream BnB listing!"
  end

end

feature 'User is able to click sign up button' do
  scenario 'user goes to sign_up screen' do
    visit '/'
    click_button('Sign Up')

    expect(page.current_path).to eq '/sign_up'
  end
end

feature 'User screen changes once signed in' do
  scenario '- new button appears' do
    visit '/'
    expect(page).not_to have_selector(:id, 'signed_in')
    add_bob_to_db
    click_button('Signed in')

    fill_in('username', with: 'Ol Bob')
    fill_in('password', with: 'damnImfine')
    click_button('Sign In')

    expect(page.current_path).to eq '/'
    expect(page).to have_selector(:id, 'signed_in')
  end
end
