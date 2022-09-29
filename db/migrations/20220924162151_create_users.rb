Sequel.migration do
  change do
    run('CREATE EXTENSION IF NOT EXISTS citext;')

    create_table(:users) do
      primary_key :id, type: :Bignum

      column :name, "character varying", null: false
      column :email, :citext, null: false, unique: true, unique_constraint_name: :index_users_on_email
      column :password_digest, "character varying", null: false
      column :created_at, "timestamp(6) without time zone", null: false
      column :updated_at, "timestamp(6) without time zone", null: false
    end
  end
end
