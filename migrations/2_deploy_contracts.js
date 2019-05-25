// const Count = artifacts.require('./Count.sol')
// const fs = require('fs')

// module.exports = function (deployer) {
//   deployer.deploy(Count)
//     .then(() => {
//     // Record recently deployed contract address to 'deployedAddress' file.
//     if (Count._json) {
//       // Save abi file to deployedABI.
//       fs.writeFile(
//         'deployedABI',
//         JSON.stringify(Count._json.abi, 2),
//         (err) => {
//           if (err) throw err
//           console.log(`The abi of ${Count._json.contractName} is recorded on deployedABI file`)
//         })
//     }

//     fs.writeFile(
//       'deployedAddress',
//       Count.address,
//       (err) => {
//         if (err) throw err
//         console.log(`The deployed contract address * ${Count.address} * is recorded on deployedAddress file`)
//     })
//   })
// }
const SigStockRegistry = artifacts.require('./registry/SigStockRegistry')
const Product = artifacts.require('./product/Product');
const BasicInvestModule = artifacts.require('./modules/basic/BasicInvestModule');
const BasicPurchaseModule = artifacts.require('./modules/basic/BasicPurchaseModule');
const BasicDivideModule = artifacts.require('./modules/BasicDivideModule');

module.exports = async function (deployer) {
  
  await deployer.deploy(SigStockRegistry);
  await deployer.deploy(Product, '모나리자', '눈썹없는 여인', 2, 1000);
  await deployer.deploy(BasicInvestModule, Product.address, SigStockRegistry.address);
  await deployer.deploy(BasicPurchaseModule, Product.address, SigStockRegistry.address);
  await deployer.deploy(BasicDivideModule, Product.address, SigStockRegistry.address);
  
}