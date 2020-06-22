# be-typescript-express

## Project setup

### Configure .npmrc
Configure the `.npmrc` file to download the npm dependencies from the internal Nexus Host.

```
registry= <nexus host url>
always-auth=true
_auth= <base64 encoded nexus credentials>
email=
```

### Installs npm dependencies
```
npm install
```

### Actively transpiles typescript to Javascript into dist folder
```
npm run build
```

### Tests the spec files under `dist/__test__` folder and generates a coverage report
```
npm run test
```

### Runs node web server
```
npm run start
```
