feature 'user able to sign up' do
  scenario '- user clicks sign up button' do
    visit '/'
    click_button('Sign Up')

    expect(page.current_path).to eq '/sign_up'
  end

  scenario '- user to enter details adn submit' do
    visit '/'
    click_button('Sign Up')
    fill_in('name', with: 'Ol Bob')
    fill_in('email', with: 'OlBob@hickorydock.com')
    fill_in('phone', with: '0155566666')
    fill_in('password', with: 'damnImfine')
    click_button('submit')

    expect(page.current_path).to eq '/'
    expect(page).to have_selector(:id, 'sign_out')
  end
end
