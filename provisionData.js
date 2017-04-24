var fs = require('fs');
var unzip = require('unzip');

var fileList = ['FD_GROUP.txt', 'FOOD_DES.txt', 'NUTR_DEF.txt', 'NUT_DATA.txt'];
var temporaryFileExtension = '.out';
var usdaDatabaseZipName = 'sr28asc.zip';


function unzipUsdaDatabaseToTemporaryFiles(sourceDataFolder) {
    return new Promise(function (resolve, reject) {

        if (!fs.existsSync(sourceDataFolder)) {
            reject("folder: " + sourceDataFolder + " does not exist");
        }

        sourceDataFolder + usdaDatabaseZipName;

        fs.createReadStream(sourceDataFolder + usdaDatabaseZipName)
            .pipe(unzip.Parse())
            .on('entry', function (entry) {

                if (fileList.includes(entry.path)) {
                    entry.pipe(fs.createWriteStream(sourceDataFolder + entry.path + temporaryFileExtension));
                } else {
                    entry.autodrain();
                }

                resolve();
            });
    });
}

module.exports = function (sourceDataFolder, outputJsonPath) {
    return unzipUsdaDatabaseToTemporaryFiles(sourceDataFolder)
};