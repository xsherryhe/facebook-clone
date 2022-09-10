class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  before_validation :sanitize_string_attributes

  private

  def sanitize_string_attributes
    attributes.each do |_, value|
      value.delete!("\u0000") if value.is_a?(String) && !value.frozen?
    end
  end
end
