# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

FactoryGirl.define do
  factory :user do
    name      'John Doe'
    email     'john@example.com'
    role      'admin'
    password  'secret'
    password_confirmation 'secret'

    after(:create) do |user, evaluator|
      user.update_attributes(
        name: evaluator.name,
        email: evaluator.email,
        role: evaluator.role,
        password: evaluator.password,
        password_confirmation: evaluator.password_confirmation
      )
    end
  end
end
