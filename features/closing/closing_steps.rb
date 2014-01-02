require "bundler"
Bundler.require(:default)
require "active_support/core_ext"
require_relative '../../../step_functions.rb'

require 'pry'

Before do
  @@full_name = 'Test845 Test444' #has an approval
  before
end

After do |scenario|
  after(scenario)
end

AfterStep do |scenario|
  @t_driver.wait_to_disappear(:id,"load-mask-container")
  #make sure there's no error report 
  if @t_driver.find_elements(:id,"alert-messenger").size>0 and @t_driver.find_element(:id,"alert-messenger").displayed?
    bool = true
  else
    bool = false
  end 
  
  assert_equal(false,bool)
end

Given(/^I'm at url '(.*?)'$/) do |url|
  url(url)
end

Given(/^I sign in$/) do
  @t_driver.send_keys(:name,"uid","jprince")
  @t_driver.send_keys(:name,"password","4p5v3sxQ")
  @t_driver.wait_and_click(:id,"submit-login-form")
  @t_driver.wait_to_disappear(:id,"load-mask-container")
  
end

Given(/^I find the global customer$/) do
  @t_driver.wait_and_click(:id,"pcore-search")
  @t_driver.send_keys(:id,"pcore-search", @@full_name)
  @t_driver.send_keys(:id,"pcore-search", :return)
  @t_driver.wait_to_appear(:xpath,'//*[@id="search-results"]/div[2]')
  @wait.until {
    @t_driver.find_element(:xpath,'//*[@id="search-results"]/div[2]/div[1]/h4').text.include?(@@full_name)     
  }
  @t_driver.wait_and_click(:xpath,'//*[@id="search-results"]/div[2]')
end

And(/^I navigate to the history tab$/) do
  @t_driver.wait_and_click(:css,'a[href="#customer-history"]')
end

Then(/^I should see an approval with a lease signing button$/) do
  assert_equal(@t_driver.find_element(:class,'set-lease-signing').size != 0,true)
end

Given(/^I click set lease signing$/) do
  @t_driver.execute_script('$(".set-lease-signing").first().click();') #click first set-lease-signing in the DOM
  @t_driver.wait_to_appear(:id,"closing-times")
end

def find_available_leasing_times
  @wait.until {
    @t_driver.find_element(:class, 'leasing-times')
  }
  if @t_driver.execute_script('$(".reserve-time").is(":visible");')
    return true
  else  
    @t_driver.execute_script("$('a[href=\".tab-7\"]').click();") #tab-7 almost always has times
  end
end

Then(/^I should see the modal with available times$/) do
  @t_driver.wait_to_appear(:class,"leasing-times")
  find_available_leasing_times
end

Given(/^I click the first available lease signing and click confirm$/) do
  @t_driver.execute_script("$('.reserve-time').first().click();")
  sleep(5) # wait for confirm modal to come down
  @t_driver.wait_and_click(:xpath,'//*[@id="closing-confirm"]/div[3]/button[2]')
end

Then(/^I should see a lease signing object on the history tab$/) do
  @t_driver.wait_to_disappear(:id,"load-mask-container")
  @@time = @t_driver.execute_script("$('.leasesigning .page-header h4').first().text();")
  # vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
  # Make sure first signing in DOM is status set
  # vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
  @t_driver.execute_script("$('.leasesigning .showing-state').first().text() === 'Lease Signing Set' ? true : false ;")  
end

Given(/^I click the reschedule button$/) do
  @t_driver.execute_script('$(".reschedule-signing").first().click();')
  @t_driver.wait_to_appear(:id,"closing-times")
end

Then(/^I should see a lease signing object on the history tab with a changed time$/) do
  @t_driver.wait_to_disappear(:id,"load-mask-container")
  # vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
  # Make sure first signing in DOM is status set
  # vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
  @t_driver.execute_script("$('.leasesigning .showing-state').first().text() === 'Lease Signing Set' && $('.leasesigning .page-header h4').first().text() !== '#{@@time}' ? true : false;")
end

Given(/^I click the cancel button$/) do
  @t_driver.execute_script('$(".cancel-signing-modal").first().click();')
end

Then(/^I should see the canceling reason modal$/) do
  @t_driver.wait_to_appear(:id,"closing-cancel")
end

Given(/^I select a party and a reason$/) do
  @t_driver.form_fillout_selector({
                                    "closing-canceled-by"=>"Pangea",
                                    "closing-canceled-reason"=>"Other"
                                  })
end

Given(/^I click confirm$/) do
  @t_driver.execute_script('$("#cancel-signing-trigger").click();')  
end

Then(/^I should see a lease signing object on the history tab that is canceled$/) do
  @t_driver.wait_to_disappear(:id,"load-mask-container")
  # vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
  # Make sure first signing in DOM is status canceld
  # vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
  @t_driver.execute_script("$('.leasesigning .showing-state').first().text() === 'Cancelled' ? true : false;")
end
