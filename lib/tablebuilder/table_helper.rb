require 'tablebuilder/table_builder'

module Tablebuilder
  module TableHelper

    def table_for(model, options = {})
      builder = TableBuilder.new(model, self, options)
      with_output_buffer do
        yield builder
      end
      builder.render_table
    end

    def table_row_id_for(object)
      Tablebuilder::TableBuilder.row_id_for(object)
    end

  end
end

