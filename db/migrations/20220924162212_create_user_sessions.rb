Sequel.migration do
  change do
    create_table(:user_sessions) do
      primary_key :id, type: :Bignum

      column :uuid, "character varying", null: false
      column :created_at, "timestamp(6) without time zone", null: false
      column :updated_at, "timestamp(6) without time zone", null: false

      index [:uuid], name: :index_uuid_on_user_sessions
      foreign_key :user_id, :users
    end
  end
end
