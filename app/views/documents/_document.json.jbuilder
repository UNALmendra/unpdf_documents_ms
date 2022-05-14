json.extract! document, :id, :name, :type, :user, :storage, :created_at, :updated_at
json.url document_url(document, format: :json)
