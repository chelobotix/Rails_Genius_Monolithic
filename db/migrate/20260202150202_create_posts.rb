class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts do |t|
      t.jsonb :title, default: {}
      t.jsonb :description, default: {}
      t.jsonb :body, default: {}
      t.string :image_url, null: true
      t.string :thumbnail_url, null: true
      t.string :tags, null: true
      t.integer :words, null: false
      t.boolean :featured, default: false
      t.string :status, null: false, default: "draft"
      t.integer :year, null: false

      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
