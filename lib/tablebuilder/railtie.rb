require 'tablebuilder/table_helper'

class Tablebuilder::Railtie < Rails::Railtie

  config.before_initialize do
    ActionView::Base.send :include, Tablebuilder::TableHelper
  end

end

