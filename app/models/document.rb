class Document
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :type, type: String
  field :user, type: String
  field :storage, type: String
end
