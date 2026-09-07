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

You can validate a single IDMEFv2 message (a plain JSON object), or several messages at once by wrapping them in a JSON array, e.g. `[ { ... }, { ... } ]`. Each object in the array is validated independently against the schema, and the results panel reports which object(s) failed (`Object [index]`) and why. Error highlighting in the editor also understands both shapes, so a batch of messages is checked as you type, not just when you press "Validate".

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

## Technical overview

### Editor and validation engine

The validator is a static web page (`Validator/validator.html`, `Validator/script.js`, `Validator/style.css`) with no backend:

- **Monaco Editor** (the same editor used by VS Code) provides the JSON text area, syntax highlighting, and live inline diagnostics.
- **Ajv** (a JSON Schema validator) compiles the currently loaded IDMEFv2 schema and runs the full validation when you press "Validate".
- The same schema is also handed to Monaco's own JSON language service, so it can flag structural problems (missing/extra properties, wrong types, etc.) while you type, before you even press "Validate".

### Single message vs. batch validation

- If the editor content is a JSON object, it is validated as a single IDMEFv2 message.
- If the editor content is a JSON array, each element is validated independently against the schema; the results panel lists, per object, whether it passed and, if not, the `Path`/`Error` pairs for that object.
- To support both shapes with live, in-editor error highlighting (not only on "Validate"), the schema handed to Monaco is wrapped as `oneOf: [schema, { type: "array", items: schema }]`, keeping the schema's own `definitions` at the root of that wrapper so internal `$ref`s (e.g. `#/definitions/mediatypeType`) keep resolving correctly.

### Schema and examples versioning

The validator does not hardcode the IDMEFv2 schema or the example files: it loads them at runtime from two manifest files kept in `Validator/`:

- `Validator/drafts-manifest.json` — the list of available draft/schema version folders (e.g. `latest-stable`, `latest-dev`, `00`, `01`, ... `09-Dev`).
- `Validator/examples-manifest.json` — for each version, the list of example JSON files shown in the "Example" menu.

Both manifests are generated from the content of two git submodules:

- `Validator/drafts` → [IDMEFv2-Drafts-IETF](https://github.com/IDMEFv2/IDMEFv2-Drafts-IETF) (schema files, one folder per draft revision, plus `latest-stable`/`latest-dev`)
- `Validator/examples` → [IDMEFv2-Examples](https://github.com/IDMEFv2/IDMEFv2-Examples) (example JSON messages, one folder per version)

On startup, the validator tries to load the schema from the `latest-stable` folder directly; if that fails, it reads `drafts-manifest.json` to pick the most recent available folder as a fallback, and the version dropdown is populated the same way.

## Coding process

### Web page for JSON message validation (Coding/validation process)

On every push to https://github.com/IDMEFv2/IDMEFv2-JSON-Validator

Copy Validator's files to https://github.com/IDMEFv2/IDMEFv2.github.io in the folder Validator-PP so this URL is always up to date :  https://idmefv2.github.io/Validator-PP/validator.html

When pushing a tag to  https://github.com/IDMEFv2/IDMEFv2-JSON-Validator

Copy Validator's files to https://github.com/IDMEFv2/IDMEFv2.github.io in the folder Validator so this URL is up to date when releasing :  https://idmefv2.github.io/Validator/validator.html

Validator-PP folder is for staging
Validator folder is for "release"

### Updating the validator for a new draft release

When a new IDMEFv2 draft revision (or a new set of examples) is published upstream, the validator itself doesn't need any code change — you only need to refresh the submodules and the manifests that describe what versions are available:

1. **Update the submodules** to pull in the new draft/examples folders:
   ```
   git submodule update --remote Validator/drafts
   git submodule update --remote Validator/examples
   ```
   This checks out the latest commit of each submodule's tracked branch. Only run the one(s) that actually changed (e.g. just `Validator/drafts` if only the schema was updated).

2. **(Optional) Regenerate the manifests locally** if you want to try the new draft/examples in your local copy of the validator:
   ```
   pwsh ./scripts/generate-manifests.ps1
   ```
   This scans `Validator/drafts/IDMEFv2` and `Validator/examples`, and rewrites `Validator/drafts-manifest.json` and `Validator/examples-manifest.json` accordingly. Folder names must follow the existing convention (`latest-stable`, `latest-dev`, a plain revision number like `08`, or `NN-Dev` for a dev revision) or the validator will not pick them up — see [Schema and examples versioning](#schema-and-examples-versioning). Both manifest files are listed in `.gitignore` and are never committed to the repo; this step is here only for completeness, since `.github/workflows/build.yml` (push to `main`) and `.github/workflows/build2.yml` (push of a tag) already run this exact script automatically before every deploy.

3. **Commit** the updated submodule references:
   ```
   git add Validator/drafts Validator/examples
   git commit -m "Update drafts/examples submodules for draft revision X"
   ```

4. **Push to `main`.** This triggers `.github/workflows/build.yml`, which regenerates the manifests and copies `Validator/` to the staging site (`Validator-PP`). Check the new version there (version dropdown, examples, exercises) before releasing.

5. **Tag the release** once verified. This triggers `.github/workflows/build2.yml`, which regenerates the manifests again and copies `Validator/` to the production `Validator` folder.
