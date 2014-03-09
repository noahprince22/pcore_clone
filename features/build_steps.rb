require "bundler"
Bundler.require(:test)

Before do
  unless @driver
    if ENV['BUILD_MODE'].eql?('grid')
      require_relative '/data/pangea/build/current/step_functions.rb'
      before
      @driver = config_driver
    else
      browser = ENV['BROWSER']
      browser||="chrome"
      @driver = TelluriumDriver.new(browser, 'local')    
      @driver.go_to("http://google.com/")
    end
  end
  @driver.manage.window.maximize # pcore wont run if the window is too small
end

After do |scenario|
  if @driver
    after(scenario) if ENV['BUILD_MODE'].eql?('grid')
    @driver.save_screenshot(scenario.raw_steps[0].name.gsub(" ","_")+".png")
    if @driver
      @driver.close 
      @driver = nil
    end
  end
end
