Given /^user "(.*?)" exists$/ do |handle|
  raise unless UserModel.new.get_user_by_handle(handle)
end

Given /^user "(.*?)" does not exist$/ do |handle|
  raise if UserModel.new.get_user_by_handle(handle)
end
