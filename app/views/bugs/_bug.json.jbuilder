json.extract! migration, :id, :CreateBugs, :title, :description, :project_id, :deadline, :type, :status, :created_at, :updated_at
json.url migration_url(migration, format: :json)
