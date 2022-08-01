# Simplio Wallet v2

Mobile application written in Flutter.

## Running application

The easiest way is to run it with `run.sh` script. In order to do that you need to define
API_KEY and API_URL in your `.bashrc` or `.zshrc` file. See `run.sh` for details.

## Developing guidelines

* Use autoformatting tools. See `pre-commit` file in `.github` folder and copy it into your 
`.git/hooks` folder.

## Generating code

```bash
flutter packages pub run build_runner build
```
