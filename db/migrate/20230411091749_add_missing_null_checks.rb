class AddMissingNullChecks < ActiveRecord::Migration[7.0]
  def change # это проверка на присутствие полей (название таблицы, название колонки и должен ли быть пустым)
    change_column_null :questions, :title, false 
    change_column_null :questions, :body, false
    change_column_null :answers, :body, false
  end
end
