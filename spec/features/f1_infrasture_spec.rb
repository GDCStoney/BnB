feature 'User is able to access homepage' do
  scenario 'user sees title of application' do
    visit '/'

    expect(page).to have_content "Welcome to the BEST Beaches and Stream BnB listing!"
  end

end

feature 'User is able to see sign up button' do
  scenario 'user can click sign up button' do
    visit '/'
    click_button('Sign Up')

    expect(page.current_path).to eq '/sign_up'
  end
end

feature 'User screen changes once signed in' do
  scenario '- new button appears' do
    visit '/'
    click_button('Sign In')

    expect(page.current_path).to eq '/'
    expect(page.find_button('Signed In')).to be_truthy
  end
end
