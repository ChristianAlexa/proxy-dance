// import
const data = require("../temp/dependencies.json");
const privateDependencies = require("./privateDependencies.json");

// get arg from running the script (expecting public or private)
const args = process.argv.slice(2);

let pkgAndVersionList = [];

// build 1 list for public package@version and 1 list for private package@version
switch (args[0]) {
  case 'public':
    for (const key in data.dependencies) {
      let pkgName;
      let pkgVersion;
      let pkgAndVersion;

      if (data.dependencies.hasOwnProperty(key) && !privateDependencies.packgeNames.includes(key)) {
        pkgName = key;
        pkgVersion = data.dependencies[key].version;
        pkgAndVersion = pkgName + '@' + pkgVersion;
        pkgAndVersionList.push(pkgAndVersion);
      }
    }
    break;
  case 'private':
    for (const key in data.dependencies) {
      let pkgName;
      let pkgVersion;
      let pkgAndVersion;

      if (data.dependencies.hasOwnProperty(key) && privateDependencies.packgeNames.includes(key)) {
        pkgName = key;
        pkgVersion = data.dependencies[key].version;
        pkgAndVersion = pkgName + '@' + pkgVersion;
        pkgAndVersionList.push(pkgAndVersion);
      }
    }
    break;
  default:
    console.log('Error: unaccepted arg. Please use arguement public or private');
}

if (pkgAndVersionList.length > 0) {
  pkgAndVersionList.forEach(p => {
    console.log(p);
  })
}
