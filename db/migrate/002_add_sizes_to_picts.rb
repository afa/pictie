Sequel.migration do
  change do
    alter_table :picts do
      add_column :width, Integer, null: false
      add_column :height, Integer, null: false
      add_column :original, TrueClass, null: false, default: true
      add_column :crypto_hash, String, null: false
    end
    add_index :picts, [:crypto_hash]
    add_index :picts, [:width, :height]
    add_index :picts, [:original]
  end
end
