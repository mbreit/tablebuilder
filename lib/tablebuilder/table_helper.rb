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
  end
end

