pragma solidity >=0.4.24;

import "../../interface/InterfacePurchaseModule.sol";
import "../../library/ReentrancyGuard.sol";
import "../../library/SafeMath.sol";
/**
* @dev 기본적인 구매 모듈  ( 추후 구매자를 위한 )
*
* 
* 
* 
 */

contract BasicPurchaseModule is InterfacePurchaseModule, ReentrancyGuard {
    using SafeMath for uint256;

    event ProductPurchase(address indexed sigStockProduct, address indexed beneficiary, uint256 amount);
    event LogGranularityChanged(uint256 _oldGranularity, uint256 _newGranularity);
    
    struct PurchaseData {
        address product;
        address purchaser;
        uint256 amount;
        uint256 timeStamp;
    }

    uint public granularity;
    uint256 public productSold;
    address public fundsWallet;
    uint256 public purchaserCount;
    mapping (address => uint256) public purchasers;
    mapping (uint256 => PurchaseData) private _purchaseList;
    
    constructor (address _registry, address _product) public
    InterfaceModule(_registry, _product)
    {
        
    }

    function () external payable {
        purchaseProduct(msg.sender);
    }
    modifier checkGranularity(uint256 _amount) {
        require(_amount % granularity == 0, "Unable to modify token balances at this granularity");
        _;
    }
    
    function changeGranularity(uint256 _granularity) public returns(bool) {
        
        require(_granularity != 0, "Granularity can not be 0");
        
        emit LogGranularityChanged(granularity, _granularity);
        
        granularity = _granularity;

        return true;
    }

    function purchaseProduct(address _investor) public payable nonReentrant returns(bool) {
        
        uint256 klayAmount = msg.value;

        _processTx(_investor, klayAmount);

        return true;
    }

    function _processTx(address _beneficiary, uint256 _investedAmount) internal {

        _preValidateInvest(_beneficiary, _investedAmount);
        // calculate token amount to be created
        uint256 klays = _investedAmount;

        // update state
        productSold = productSold.add(_investedAmount);

        _processPurchase(_beneficiary, klays);

        _forwardFunds();
        
        emit ProductPurchase(sigStockProduct, _beneficiary,  klays);

    }
    
    function _preValidateInvest(address _beneficiary, uint256 _investedAmount) internal view {
        require(_beneficiary != address(0), "Beneficiary address should not be 0x");
        require(_investedAmount != 0, "Amount invested should not be equal to 0");
    }
    /**
    * @notice Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
    * @param _beneficiary Address receiving the tokens
    * @param _tokenAmount Number of tokens to be purchased
    */
    function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
        
        if (purchasers[_beneficiary] == 0) {
            purchaserCount = purchaserCount + 1;
        }

        purchasers[_beneficiary] = purchasers[_beneficiary].add(_tokenAmount);

    }

    function _forwardFunds() internal {
        fundsWallet.transfer(msg.value);
    }

    function getType() public view returns(uint8) {
        return 2;
    }
    
    function getRaisedKlay() public view returns (uint256) {       
        return productSold;
    }

    function getName() public view returns(bytes32) {
        return "BasicPurchaseModule";
    }
}