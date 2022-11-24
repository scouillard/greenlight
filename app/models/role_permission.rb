# frozen_string_literal: true

class RolePermission < ApplicationRecord
<<<<<<< HEAD
  belongs_to :role
=======
  belongs_to :permission
  belongs_to :role

  validates :value, presence: true
>>>>>>> 5a3eb37130dbeeddf333366e83bfc929424877c8
end
