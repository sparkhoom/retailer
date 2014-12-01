# encoding: utf-8
class PhoneNumberFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    unless value =~ /^1[3|4|5|8][0-9]\d{4,8}$/
      object.errors[attribute] << (options[:message] || "格式不正确")
    end
  end
end 