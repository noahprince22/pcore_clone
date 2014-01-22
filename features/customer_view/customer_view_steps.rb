require "bundler"
Bundler.require(:default)
require "active_support/core_ext"
require_relative '../../../step_functions.rb'

require 'pry'
require 'test/unit'
Before do
 before
end

After do |scenario|
 after(scenario)
end

AfterStep do |scenario|
  bool=false
  @t_driver.wait_to_disappear(:id,"load-mask-container")
  #make sure there's no error report 
  if @t_driver.find_elements(:id,"alert-messenger").size>0 and @t_driver.find_element(:id,"alert-messenger").displayed?
    bool = true
  else
    bool = false
  end 
   
  raise "An alert was raised" if bool
  # asse rt_equal(false,bool)
end

Given(/^I'm at url '(.*?)'$/) do |url|
  build_url(url)
end

Given(/^I sign in$/) do
  @t_driver.send_keys(:name,"uid","jprince")
  @t_driver.send_keys(:name,"password","4p5v3sxQ")
  @t_driver.wait_and_click(:id,"submit-login-form")
  @t_driver.wait_to_disappear(:id,"load-mask-container")
  
end

Given(/^I create an customer from scratch$/) do 
  @t_driver.wait_and_click(:xpath,'//*[@id="global-navbar"]/div/div/div[1]/ul/li/a')
  @t_driver.wait_and_click(:css,"[data-module=customer]")
  # @type = "applicants"
  steps %Q{
    Given I fill out the customers form
  }
  @t_driver.wait_and_click(:id, "save-customer")
  @t_driver.wait_to_appear(:id,"load-mask-container")
  @t_driver.wait_to_disappear(:id,"load-mask-container")
end

Then(/^the customer should exist$/) do
  @t_driver.wait_and_click(:id,"pcore-search")
  @t_driver.send_keys(:id,"pcore-search", @@full_name)
  @t_driver.send_keys(:id,"pcore-search", :return)
  @t_driver.wait_to_appear(:css,"#search-results .row-fluid")  
  assert_equal(@t_driver.find_element(:xpath,'//*[@id="search-results"]/div[2]/div[1]/h4').text.include?(@@full_name),true)
end

Given(/^I fill out the customers form$/) do
  @@first_name = "Test#{(Random.new.rand*1000).to_i.to_s}"
  @@last_name = "Test#{(Random.new.rand*1000).to_i.to_s}"
  @@full_name = @@first_name+' '+@@last_name 
  @t_driver.form_fillout_editable("customer",{
    "first_name"=> @@first_name,
    "last_name"=>@@last_name,
    "email"=>@@first_name+@@last_name+"@testing.com",
    "dob"=>"02/21/1989",
    "mobile_phone"=>"5555555555",
    "home_phone"=>"1111111111",
    "work_phone"=>"2343454565",
    "master_lead_provider"=>"Publication",
    "sub_lead_provider"=>"test",
    "reac_lead"=>"test"
   })
end

Given(/^I find the global customer$/) do
  @t_driver.wait_and_click(:id,"pcore-search")
  @t_driver.send_keys(:id,"pcore-search", @@full_name)
  @t_driver.send_keys(:id,"pcore-search", :return)
  @t_driver.wait_to_appear(:css,"#search-results .row-fluid")
  @wait.until {
    @t_driver.find_element(:xpath,'//*[@id="search-results"]/div[2]/div[1]/h4').text.include?(@@full_name)    
  }
  @t_driver.wait_and_click(:xpath,'//*[@id="search-results"]/div[2]/div[1]')
end

And(/^I edit the customers email$/) do
  @t_driver.wait_and_click(:xpath,'//*[@id="customer-fields-wrapper"]/div[1]/div[1]/div/div/a') #email
  @t_driver.wait_and_click(:css,'.editable-clear-x')
  @t_driver.send_keys(:xpath,'//*[@id="customer-fields-wrapper"]/div[1]/div[1]/div/div/span/div/form/div/div[1]/div[1]/input',"edited"+@@first_name+@@last_name+"@testing.com")
  @t_driver.wait_and_click(:css,"button.btn.editable-submit" )
  sleep(1)
end

Then(/^the customers email should update$/) do
  @t_driver.wait_and_click(:id,"pcore-search")
  @t_driver.send_keys(:id,"pcore-search", @@full_name)
  @t_driver.send_keys(:id,"pcore-search", :return)
  @t_driver.wait_to_appear(:css,"#search-results .row-fluid")  
  @wait.until {
    @t_driver.find_element(:xpath,'//*[@id="search-results"]/div[2]/div[1]/h4').text.include?(@@full_name)    
  }
  assert_equal(@t_driver.find_element(:xpath,'//*[@id="search-results"]/div[2]/div[2]/h4').text.include?('edited'),true)
end

And(/^I add notes to the customer$/) do
  @t_driver.form_fillout_selector({"note-type-select"=>"None"})
  @t_driver.wait_and_click(:id,"note-message")
  @t_driver.send_keys(:id,"note-message", "This is a test note #{(Random.new.rand*1000).to_i.to_s}")
  sleep(2) #wait for button to become enabled
  @t_driver.wait_and_click(:xpath,'//*[@id="new-note-form"]/input[2]')
  @t_driver.wait_to_appear(:xpath,'//*[@id="customer-notes"]/table/tbody/tr[1]')    
end

Then(/^the customers notes should update$/) do
  @t_driver.wait_and_click(:id,"pcore-search")
  @t_driver.send_keys(:id,"pcore-search", @@full_name)
  @t_driver.send_keys(:id,"pcore-search", :return)
  @t_driver.wait_to_appear(:css,"#search-results .row-fluid")  
  @wait.until {
    @t_driver.find_element(:xpath,'//*[@id="search-results"]/div[2]/div[1]/h4').text.include?(@@full_name)    
  }
  @t_driver.wait_and_click(:xpath,'//*[@id="search-results"]/div[2]')
  @t_driver.wait_to_appear(:id,'customer-notes')
  @t_driver.execute_script('$("#customer-notes table tbody tr").length ? false : true')
end
