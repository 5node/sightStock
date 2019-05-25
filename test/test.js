const SigStockRegistry = artifacts.require('./registry/SigStockRegistry')
const Product = artifacts.require('./product/Product');
const BasicInvestModule = artifacts.require('./modules/basic/BasicInvestModule');
const BasicPurchaseModule = artifacts.require('./modules/basic/BasicPurchaseModule');
const BasicDivideModule = artifacts.require('./modules/BasicDivideModule');
const bignumber = require('bignumber.js');
contract('sigstock test', accounts => {

    const BigNumber = web3.BigNumber;

    require('chai')
        .use(require('chai-as-promised'))
        .use(require('chai-bignumber')(BigNumber))
        .should();

    const [account1, account2, account3, account4, account5, account6, account7, 
        account8, account9, account10
    ] = accounts;
    let registry, product1, product2, investModule, purchaseModule, divideModule;
    
    async function init() {
        
        registry = await SigStockRegistry.new({from:account1});
        
        await registry.addSigStockAdmin(account2, 0,{from:account1}).should.be.fulfilled;
        
        await registry.addCreator(account2,{from:account2}).should.be.fulfilled;

        await registry.createProduct("모나리자","눈썹없는 여인",2,1000, {from:account2}).should.be.fulfilled;
        
        let productAddress  = await registry.creatorProducts(account2,0);

        product1 = await Product.at(productAddress,{from:account2});
        
        //작품 추가
        let creatorRate = await product1.creatorRate();

        investModule = await BasicInvestModule.new(product1.address, registry.address, {from:account2});
        purchaseModule = await BasicPurchaseModule.new(product1.address, registry.address, {from:account2});
        divideModule = await BasicDivideModule.new(product1.address, registry.address, {from:account2});

    }
    describe("1. basic", async() => {
        it("1", async() => {
            await init();
        })

        it("2. addModule", async()=> {
            
            await product1.addModule(investModule.address,{from:account2});
            await product1.addModule(purchaseModule.address,{from:account2});
            await product1.addModule(divideModule.address,{from:account2});
            
            //check
            let addr1 = await product1.module(1);
            let addr2 = await product1.module(2);
            let addr3 = await product1.module(3);

            assert.equal(investModule.address, addr1);
            assert.equal(purchaseModule.address, addr2);
            assert.equal(divideModule.address, addr3);
        })
        //product1 컨트랙트에서 setConfigure를 통해서 investModule의 상태값 변경한다.
        it("3. setConfigre", async() => {
            const startTime = Date.now() + 10;
            console.log(startTime);
            const endTime = Date.now()+86400;
            const cap = bignumber(1e+18);
            
            await product1.setInvestConfigure(startTime, endTime, cap, 20, divideModule.address,{from:account2}).should.be.fulfilled;
        })
    })
});
