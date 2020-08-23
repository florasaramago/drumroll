class User < ApplicationRecord
  devise :database_authenticatable, :confirmable, :registerable,
         :recoverable, :rememberable, :validatable
end
