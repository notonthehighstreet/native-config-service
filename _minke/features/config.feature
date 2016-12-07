@config
Feature: Health check
	In order to ensure quality
	As a user
	I want to be able to test functionality of my API

Scenario: Config endpoint returns the correct config
	Given I send a GET request to "/v1/config/giftfinder/a"
	Then the response status should be "200"
	And the JSON response should have "$..base" with the text "notonthehighstreet.com"

Scenario: Config endpoint returns nothing with invalid parameters
	Given I send a GET request to "/v1/config/giftfinder/aa"
	Then the response status should be "400"
