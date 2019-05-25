const SigStockRegistry = artifacts.require('./registry/SigStockRegistry')
const Product = artifacts.require('./product/Product');
const BasicInvestModule = artifacts.require('./modules/basic/BasicInvestModule');
const BasicPurchaseModule = artifacts.require('./modules/basic/BasicPurchaseModule');
const BasicDivideModule = artifacts.require('./modules/BasicDivideModule');

contract('Kynee20Registry test', accounts => {

    const BigNumber = web3.BigNumber;

    require('chai')
        .use(require('chai-as-promised'))
        .use(require('chai-bignumber')(BigNumber))
        .should();

    const [registryOwner, tokenHiddenOwner, tokenSuperOwner, tokenOwner, tetherOwner,
        registrySuperOwner, newRegistryOwner, registryHiddenOwner, registryAdmin, investor1
    ] = accounts;
});
