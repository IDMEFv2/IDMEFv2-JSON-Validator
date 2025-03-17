# IDMEFv2-JSON-Validator

## User manual

### Introduction
The IDMEFv2 JSON-Validator is an online "wizard" for creating/testing/validating IDMEFv2 JSON messages
You can create a message from scratch, load an existing message and edit it, play with excercices and examples.
The IDMEFv2-JSON-Validator is the perfect tool to discover and learn IDMEFv2.

### Online Draft

Connect to https://datatracker.ietf.org/doc/draft-lehmann-idmefv2/ for classes and attributes description.

### Latest version access

The latests version is available at: https://idmefv2.github.io/Validator/validator.html

(VALIDATION version: https://idmefv2.github.io/Validator-PP/validator.html)

### Message validation

To validate a JSON message you can either:
- Cut and paste the JSON file in the left text area
- Upload a JSON file

Then press the "validate" button and the result will be displayed in the right text area. Then you can correct potential errors. 

### Examples and Excercises

You can upload examples (without errors) and excercices (with errors) to train or as a template for your own IDMEFv2

### Edit functions

You can copy-paste the textarea content or save your work in a local file.

### Errors meaning (To be completed)
 
- Path: Root.Severity, Error: should NOT have additional properties : The "Severity" attributes doesn't exist in the Root class (Alert classe)
- Path: Vector[0].Category[0], Error: should be equal to one of the allowed values : Category value of the vector class should be a value from the enum allowed
- Path: Attachment[0], Error: should have required property 'Name' : Attachment class MUST have a "Name" attribute value

### The IDMEFv2 specification evolve

Keep in mind that the draft format is still evolving with no backward compatibility at this time, so some attributes may appear or disappear between draft versions.

## Coding process

### Web page for JSON message validation (Coding/validation process)

On every push to https://github.com/IDMEFv2/IDMEFv2-JSON-Validator

Copy Validator's files to https://github.com/IDMEFv2/IDMEFv2.github.io in the folder Validator-PP so this URL is always up to date :  https://idmefv2.github.io/Validator-PP/validator.html

When pushing a tag to  https://github.com/IDMEFv2/IDMEFv2-JSON-Validator

Copy Validator's files to https://github.com/IDMEFv2/IDMEFv2.github.io in the folder Validator so this URL is up to date when releasing :  https://idmefv2.github.io/Validator/validator.html

Validator-PP folder is for staging
Validator folder is for "release"
