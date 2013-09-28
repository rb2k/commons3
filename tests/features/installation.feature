Feature: Site installation
  Scenario: Installation succeeded
    Given I am on "/"
    Then I should see "Oh hai"
  
  @javascript
  Scenario: Installation succeeded with js enabled
    Given I am on "/"
    Then I should see "Oh hai"
  
  # Drush currently splits the output in table form
  # And feature-list doesn't support --pipe or output formats
  # the 'not contain' step https://drupal.org/node/2100105
  # table problems: https://drupal.org/node/2099753
  # That's why we just match for 'space space O'
  @api
  Scenario: No features are overridden
    Given I run drush "features-list"
    Then drush output should not contain "  O"