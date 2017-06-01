class AddMetricTypeToCards < ActiveRecord::Migration[5.1]
  def change
    add_column :cards, :metric_type, :integer
  end
end
