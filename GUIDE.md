## Developing guidelines

* Use autoformatting tools. See `pre-commit` file in `.github` folder and copy it into your 
`.git/hooks` folder.

## Releasing new version
For new development version deployed in app stores
developer needs to create new tag with preposition
`dev` (e.g. `dev0.0.5`). Similarly for production version
use tag with preposition `v` (e.g. `v1.0.1`).

### Generating code

```bash
flutter packages pub run build_runner build
```

### Available parameters

### 'IS_PROD' - Apps running with all features which should or shouldn't be in production
* --dart-define=IS_PROD=true / false 
* --dart-define=API_URL=PLACEHOLDER_URL
* --dart-define=API_KEY=PLACEHOLDER_KEY
* --dart-define=TEST_RUN=true / false

### Running application

The easiest way is to run it with `run.sh` script. In order to do that you need to define
API_KEY and API_URL in your `.bashrc` or `.zshrc` file. See `run.sh` for details.
