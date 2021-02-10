class Party < ApplicationRecord
  validates :duration, presence: true
  validates :start_time, presence: true
  # validate duration is numeric and > 0
  # validate start_time includes time

  belongs_to :movie
  belongs_to :host, class_name: 'User'
  has_many :viewers, dependent: :destroy
  has_many :users, through: :viewers

  def viewer_status(id)
    viewers.find_by(user_id: id).status
  end

  def strftime
    start_time.strftime("%b %d, %Y %I:%M %p %Z")
  end

  def movie_title
    Movie.find_by(id: movie_id).title
  end
end
