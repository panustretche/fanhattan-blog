class Post
  include MongoMapper::Document
  key :title, String
  key :body, String
  timestamps!

  many :comments
  validates_presence_of :title, :body

  def url
    "/#{id}/"
  end

end
