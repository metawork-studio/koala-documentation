# Koala - Documentation

# Start up python environment

1. Initiate a fresh Python virtual environment is does not exist yet.

```shell
python -m venv venv
```

OR

```shell
python3 -m venv venv
```

2. Activate a Python's environment

```shell
source venv/bin/activate
```

3. Install dependencies

```shell
pip install -r requirements.txt
```

4. The application uses a file with the `psd.psd` name. Add your own file or rename the exemplary `psd.example.psd` file for a quick demo. You will see a variety of directory structures.

5. **Mine your PSD!**

```shell
python mine-psd.py
```

##### Dump requirements

```shell
pip freeze > requirements.txt
```