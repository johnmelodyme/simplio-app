## Developing guidelines

* Use autoformatting tools. See `pre-commit` file in `.github` folder and copy it into your 
`.git/hooks` folder.

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
