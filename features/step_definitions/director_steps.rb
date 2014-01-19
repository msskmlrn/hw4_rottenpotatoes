Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |arg1, arg2|
  	Movie.find_by_title(arg1).director.should == arg2
end
