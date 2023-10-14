FactoryBot.create_list(:user, 50)
FactoryBot.create_list(:author, 50)
FactoryBot.create_list(:book_category, 20)

# FactoryBot.create_list(:category, 50)
# FactoryBot.create_list(:shelve, 20)
# FactoryBot.create_list(:book, 20)


User.create!(name: 'test', email: 'test@test.com', password: 'password', password_confirmation: 'password')
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?