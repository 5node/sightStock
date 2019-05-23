pragma solidity >=0.4.24;

import "../../interface/InterfaceInvestModule.sol";
import "../../library/ReentrancyGuard.sol";
import "../../ERC721/ERC721.sol";
import "../../ERC721/ERC721Enumerable.sol";
// import "../../library/SafeMath.sol";

/**
* @dev 기본적인 투자 모듈 ( 투자자를 위한 )
*
* 
* 
* 
 */

contract BasicInvestModule is InterfaceInvestModule, ReentrancyGuard, ERC721, ERC721Enumerable {
    using SafeMath for uint256;
    
    event DeliveredStock(uint256 tokenId, address indexed beneficiary, uint256 amount);
    event LogGranularityChanged(uint256 _oldGranularity, uint256 _newGranularity);
    event ProductInvest(address indexed investor, address indexed beneficiary, uint256 value, uint256 amount);
    
    struct InvestData {
        uint256 tokenId;
        address[] ownerHistory;
        uint256 amount;
        uint256 timeStamp;
    }
    uint public granularity;
    uint public constant rate = 1;
    uint256 public investorCount;
    uint256 public productSold;
    uint256 public fundsRaised;
    
    //configure 설정 값
    uint public startTime;
    uint public endTime;
    uint256 public cap;
    uint256 public max_investors;
    address public fundsWallet;

    mapping (address => uint256) public investors;
    mapping (uint256 => InvestData) private _InvestList;

    constructor (address _registry, address _product) public
    InterfaceModule(_registry, _product)
    {
        
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
    //TODO : 제어자 추가 컨피규어 설정값 변경
    function configure(
        uint256 _startTime,
        uint256 _endTime,
        uint256 _cap,
        uint256 _max_investors,
        address _fundsReceiver
    )
    public
    {
        require(_fundsReceiver != address(0), "Zero address is not permitted");
        require(_startTime >= now && _endTime > _startTime, "Date parameters are not valid");
        require(_cap > 0, "Cap should be greater than 0");
        startTime = _startTime;
        endTime = _endTime;
        cap = _cap;
        fundsWallet = _fundsReceiver;
        max_investors = _max_investors;
    }

    function () external payable {
        investProduct(msg.sender);
    }

    function investProduct(address _investor) public payable nonReentrant returns(bool) {
        
        uint256 klayAmount = msg.value;

        _processTx(_investor, klayAmount);

        return true;
    }

    function _processTx(address _beneficiary, uint256 _investedAmount) internal {

        _preValidateInvest(_beneficiary, _investedAmount);
        // calculate token amount to be created
        uint256 klays = _investedAmount;

        // update state
        fundsRaised = fundsRaised.add(_investedAmount);

        _processInvest(_beneficiary, klays);

        _forwardFunds();

        emit ProductInvest(msg.sender, _beneficiary, _investedAmount, klays);

    }

    function _preValidateInvest(address _beneficiary, uint256 _investedAmount) internal view {
        require(_beneficiary != address(0), "Beneficiary address should not be 0x");
        require(_investedAmount != 0, "Amount invested should not be equal to 0");
        require(productSold.add(_investedAmount) <= cap, "Investment more than cap is not allowed");
        require(now >= startTime && now <= endTime, "Offering is closed/Not yet started");
    }

    /**
    * @notice Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
    * @param _beneficiary Address receiving the tokens
    * @param _tokenAmount Number of tokens to be purchased
    */
    function _processInvest(address _beneficiary, uint256 _tokenAmount) internal {
        
        if (investors[_beneficiary] == 0) {
            investorCount = investorCount + 1;
        }

        investors[_beneficiary] = investors[_beneficiary].add(_tokenAmount);

        _deliverProductStock(_beneficiary, _tokenAmount);
    }

    function _forwardFunds() internal {
        fundsWallet.transfer(msg.value);
    }
    
    // @TODO : ERC721로 해당 사용자에게 민트 시켜주는 것 구현하기 
    function _deliverProductStock(address _beneficiary, uint256 _tokenAmount) internal {
            uint256 tokenId = totalSupply() + 1;

            _mint(_beneficiary, tokenId);

            address[] memory ownerHistory;

            InvestData memory newData = InvestData(tokenId, ownerHistory, _tokenAmount, block.timestamp);

            _InvestList[tokenId] = newData;
            _InvestList[tokenId].ownerHistory.push(_beneficiary);

            emit DeliveredStock(tokenId, _beneficiary, _tokenAmount);

    }

    function getNumberInvestors() public view returns (uint256) {
        return investorCount;
    }

    function getRaisedKlay() public view returns (uint256) {       
        return fundsRaised;
    }

    function capReached() public view returns (bool) {
        return productSold >= cap;
    }

    function getType() public view returns(uint8) {
        return 1;
    }
    
    function getName() public view returns(bytes32) {
        return "BasicInvestModule";
    }
}