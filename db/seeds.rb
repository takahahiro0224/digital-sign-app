# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.new(username: "manikorekun", email: "manikorekun@example.com", password: 'password')
user.save!

Friend.create!(
    [
        {
          user_id: user.id,
          name: '中村',
          email: 'hikusema189@keio.jp',
          description: '怠惰な大学生'
        },
        { user_id: user.id,
          name: '諭吉くん',
          email: '133522zas@protonmail.com',
          description: '偉い人'
          
        }
    ]
)