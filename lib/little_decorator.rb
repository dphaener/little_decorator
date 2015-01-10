require 'little_decorator/helper'

ActiveSupport.on_load(:action_controller) { delegate :decorate, :d, to: :view_context }
ActiveSupport.on_load(:action_view) { include LittleDecorator::Helper }

class LittleDecorator

  attr_reader :record, :view
  delegate :to_param, to: :record

  def initialize(record, view=nil)
    @record, @view = record, view
  end
  alias_method :model, :record

  def self.convert_all_units
    self.convert_all if respond_to?(:convert_all)
  end

  def method_missing(method_name, *args, &block)
    [record, view].each do |item|
      return item.public_send(method_name, *args, &block) if item.respond_to?(method_name)
    end
    super
  end

  def respond_to_missing?(method_name, include_private=false)
    [record, view].any? { |item| item.respond_to?(method_name, include_private) }
  end

end
