class Person < ApplicationRecord
  has_and_belongs_to_many :watchables, through: :people_watchables
end