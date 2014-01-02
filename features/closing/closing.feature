Feature: Closing.
  In order to test underwriting I need to test all of the application styles

  #
  Background:
    #Given I'm at url 'pc.pangeare.com'
    Given I'm at url 'https://pangea-api-dev.pangeare.com'
    # Given I'm at url 'https://localhost'
    And I sign in
    Given I find the global customer
    And I navigate to the history tab
  
  #
  @create_lease_signing
  Scenario:
    Then I should see an approval with a lease signing button
    Given I click set lease signing
    Then I should see the modal with available times
    Given I click the first available lease signing and click confirm
    Then I should see a lease signing object on the history tab
  #
  @reschedule_lease_signing
  Scenario:
    Then I should see a lease signing object on the history tab
    Given I click the reschedule button
    Then I should see the modal with available times
    Given I click the first available lease signing and click confirm
    Then I should see a lease signing object on the history tab with a changed time
  #
  @cancel_lease_signing
  Scenario:
    Then I should see a lease signing object on the history tab
    Given I click the cancel button
    Then I should see the canceling reason modal
    Given I select a party and a reason
    Given I click confirm
    Then I should see a lease signing object on the history tab that is canceled
  #

