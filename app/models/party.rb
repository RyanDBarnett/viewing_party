class Party < ApplicationRecord
  validates :mdb_id, presence: true
  validates :start_time, presence: true
  # validate duration is numeric and > 0
  # validate start_time includes time

  has_many :viewers, dependent: :destroy

  def viewer_status(id)
    viewers.find_by(user_id: id).status
  end

  def movie_title
    MovieDbFacade.get_movie_info(mdb_id).title
  end
end
