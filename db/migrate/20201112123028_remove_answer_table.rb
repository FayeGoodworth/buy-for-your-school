class RemoveAnswerTable < ActiveRecord::Migration[6.0]
  def up
    drop_table :answers
  end

  def down
    create_table :answers, id: :uuid do |t|
      t.references :question, type: :uuid
      t.string :response, null: false
      t.timestamps
    end
  end
end
