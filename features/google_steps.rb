require 'bundler'
Bundler.require(:test)

Given(/^I should be able to search$/) do
  raise "FAILLLLL BITCH"
  @driver.send_keys(:name,"q","google")
  # @driver.wait_and_click(:name,"btnK")
  @driver.wait_to_appear(:id,"extabar")
end
