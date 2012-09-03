class Comment
  include MongoMapper::EmbeddedDocument
  key :body, String
  key :user, String
  timestamps!

  belongs_to :blog
  validates_presence_of :body, :user

end

