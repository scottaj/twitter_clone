Given /^user "(.*?)" exists$/ do |handle|
  raise "User does not exist!" unless UserModel.new.get_user_by_handle(handle)
end

Given /^user "(.*?)" does not exist$/ do |handle|
  raise "User does, in fact, exist!" if UserModel.new.get_user_by_handle(handle)
end
