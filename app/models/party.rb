class Party < ApplicationRecord
  validates :duration, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :start_time, presence: true
  # validate start_time includes time

  belongs_to :movie
  belongs_to :host, class_name: 'User'
  has_many :viewers, dependent: :destroy
  has_many :users, through: :viewers

  def strftime
    start_time.strftime("%b %d, %Y %I:%M %p %Z")
  end

  def viewer_status(id)
    viewers.find_by(user_id: id).status.capitalize
  end
end
