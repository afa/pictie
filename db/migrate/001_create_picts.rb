Sequel.migration do
  change do
    create_table :picts do
      primary_key :id
      String :url, null: false

    end
    add_index :picts, [:url]
  end
end
