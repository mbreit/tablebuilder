module Tablebuilder
  class Column
    attr_accessor :column, :header, :content, :context

    def render_header
      if @header.nil?
        @context.t(".#{@column}")
      else
        call_or_output(@header)
      end
    end

    def render_content(object)
      if @content.nil?
        object.send @column
      else
        call_or_output(@content, object)
      end
    end

    private

    def call_or_output(target, *opts)
      if target.respond_to? :call
        @context.capture(*opts) do |object|
          result = target.call(*opts)
          @context.concat result if @context.output_buffer.empty?
        end
      else
        target.to_s
      end
    end
  end

  class TableBuilder
    include ActionView::Helpers::TagHelper

    attr_accessor :output_buffer

    def initialize(model_list, context, options)
      @model_list = model_list
      @context = context
      @options = options
      @columns = []
    end

    def column(column, options = {}, &block)
      col = Column.new
      col.context = @context
      col.column = column
      col.content = block || options[:content]
      col.header = options[:header]
      @columns << col
    end

    def render_table
      content_tag :table do
        render_thead + render_tbody
      end
    end

    private

    def render_thead
      content_tag :tr do
        @columns.map do |column|
          content_tag :th do
            column.render_header
          end
        end.join.html_safe
      end
    end

    def render_tbody
      content_tag :tbody do
        @model_list.map do |object|
          content_tag :tr, :class => @context.cycle("odd", "even", :name => "_tablebuilder_row") do
            @columns.map do |column|
              content_tag :td, column.render_content(object)
            end.join.html_safe
          end
        end.join.html_safe
      end
    end

  end
end

