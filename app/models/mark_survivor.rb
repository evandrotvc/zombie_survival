# frozen_string_literal: true

class MarkSurvivor < ApplicationRecord
  belongs_to :user_marked, class_name: 'User'
  belongs_to :user_report, class_name: 'User'

  after_create :mark_count

  private

  def mark_count
    user_marked.infected! if quantity_marks > 2
  end

  def quantity_marks
    MarkSurvivor.where(user_marked: user_marked.id).count
  end
end
