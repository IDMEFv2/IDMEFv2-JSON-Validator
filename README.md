# IDMEFv2-JSON-Validator

## User manual

### Introduction
The IDMEFv2 JSON-Validator is an online "wizard" for creating/testing/validating IDMEFv2 JSON messages
You can create a message from scratch, load an existing message and edit it, play with excercices and examples.
The IDMEFv2-JSON-Validator is the perfect tool to discover and learn IDMEFv2.


### Latest version access

The latests version is available at: https://idmefv2.github.io/Validator/validator.html

### Message validation

To validate a JSON message you can either:
- Cut and paste the JSON file in the left text area
- Upload a JSON file

The press the "validate" button and the result will be displayed in the left text area.

### Messages meaning

- Path: Root.Severity, Error: should NOT have additional properties : The "Severity" attributes doesn't exist in the Root class (Alert classe)
- Path: Vector[0].Category[0], Error: should be equal to one of the allowed values : Category value of the vector class should be a value from the enum allowed
- Path: Attachment[0], Error: should have required property 'Name' : Attachment class MUST have a "Name" attribute value

## Coding process

### Web page for JSON message validation (Coding/validation process)

On every push to https://github.com/IDMEFv2/IDMEFv2-JSON-Validator

Copy Validator's files to https://github.com/IDMEFv2/IDMEFv2.github.io in the folder Validator-PP so this URL is always up to date :  https://idmefv2.github.io/Validator-PP/validator.html

When pushing a tag to  https://github.com/IDMEFv2/IDMEFv2-JSON-Validator

Copy Validator's files to https://github.com/IDMEFv2/IDMEFv2.github.io in the folder Validator so this URL is up to date when releasing :  https://idmefv2.github.io/Validator/validator.html

Validator-PP folder is for staging
Validator folder is for "release"
