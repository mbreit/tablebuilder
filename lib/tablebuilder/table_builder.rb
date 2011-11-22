module Tablebuilder
  class Column
    attr_accessor :column, :header, :content, :context, :header_html, :content_html

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
      col.header_html = options[:header_html] || {}
      col.header_html[:class] ||= convert_class([], options[:class], column)
      col.content_html = options[:html] || {}
      col.content_html[:class] ||= convert_class([], options[:class], column)
      col.content_html[:style] ||= options[:style]
      @columns << col
    end

    def render_table
      content_tag :table, @options do
        render_thead + render_tbody
      end
    end

    private

    def render_thead
      content_tag :thead do
        content_tag :tr do
          @columns.map do |column|
            content_tag :th, column.header_html do
              column.render_header
            end
          end.join.html_safe
        end
      end
    end

    def render_tbody
      content_tag :tbody do
        @model_list.map do |object|
          cycle_class = @context.cycle("odd", "even", :name => "_tablebuilder_row")
          row_classes = convert_class([object], @options.delete(:row_class), cycle_class)
          content_tag :tr, :class => row_classes do
            @columns.map do |column|
              content_tag :td, column.render_content(object), column.content_html
            end.join.html_safe
          end
        end.join.html_safe
      end
    end

    def convert_class(proc_arguments, *input)
      input.map { |e| convert_class_element(proc_arguments, e) }.flatten.join(" ")
    end

    def convert_class_element(proc_arguments, input)
      [call_or_self(input, *proc_arguments) || []].flatten.map(&:to_s)
    end

    def call_or_self(object, *arguments)
      object.respond_to?(:call) ? object.call(*arguments) : object
    end
  end
end

