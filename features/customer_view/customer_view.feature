Feature: Underwriting.
  In order to test underwriting I need to test all of the application styles

  #
  Background:
    #Given I'm at url 'pc.pangeare.com'
    Given I'm at url 'https://pangea-api-dev.pangeare.com'
    # Given I'm at url 'https://localhost'
    And I sign in
  
  #
  @customer
  Scenario:
   Given I create an customer from scratch
   Then the customer should exist 
   # ^this also covers searching^
  
  #
  @edit_customer
  Scenario:
    Given I find the global customer
    And I edit the customers email
    Then the customers email should update

  #
  # @add_notes_to_customer
  # Scenario:
  #   Given I find the global customer
  #   And I add notes to the customer
  #   Then the customers notes should update

  #
    
