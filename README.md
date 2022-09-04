# Proxy Dance

## About this script

What will this script do?

* It ONLY attempts to install public npm packages and private npm packages to node_modules.
* This script does NOT modify your package.json.

Intended user for this script?

* You are a developer trying to run `npm install` for a React app and you need to use a proxy for some of the packages.

What problem does it solve?

* If you have a mix of public and private sourced packages, this will install the public repos first and then the private packages. This ordering prevents having to toggle your proxy on and off multiple times and having to run `npm install` multiple times.

When should I NOT use this?

* You don't have private repos (just use `npm install`)
* You have local libraries that you are pulling in with something like yalc (you may run into issues)

## How to run this script manually

1. Place the `proxy-dance` folder at the same level as package.json.

2. Identify all the private package names that require a proxy in package.json and add them to the array `privateDependencies.json`.

Example: Let's say you wanted to declare typescript as private repo.

You would you go to package.json

```json
  {
    "dependencies": {
      "typescript": "^4.4.2"
    }
  }
```

You would copy the package name "typescript" and put it in the privateDependencies.json files like this:

Do not include the version number.

This is what privateDependencies.json should look like if you want npm install to consider typescript as a private package to be installed on a proxy.

```json
{
  "packgeNames": [
    "typescript"
  ]
}
```

Ideally you would keep a list of proxy package names up to date in your README in a "how to run this app" subsection so the process is less manual.

3. give the proxy-dance script permission to execute
`$ chmod +x proxy-dance.sh`

4. run the proxy-dance script
`$ ./proxy-dance.sh`

You should see output in the terminal of installations happening.
If succesful, the terminal will output:

```txt
************************************************
PROCESS COMPLETE
************************************************
```

You should now have all the node_modules for all of your packages.

## How to run this script with package.json

1. Ensure the `proxy-dance` folder is at the same level as package.json.

2. Add this to scripts in package.json:

```json
"proxy-dance": "sh -ac '. ./proxy-dance/proxy-dance.sh;'"
```

3. Run the script: `npm run proxy-dance`
