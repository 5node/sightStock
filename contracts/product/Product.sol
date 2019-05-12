pragma solidity >=0.4.24;

import "../interface/InterfaceProduct.sol";


/**
*  @dev 작품 컨트랙트에서 
* addModule / removeModule 존재한다.
* getModule도 존재한다.
*
*		
 */
// 
// addModule 
// deleteModule
contract Product is InterfaceProduct {
    
    event SetConfigure(address _from, string _productTitle, string _productDescription);
    event AddedContent(address _from, bytes _contentKey, string _mainTitle, string _subTitle, uint256 _createdTime);
    event DeletedContent(address _from, uint8 _num);

    //@ TODO : addContent - 제어자 추가해야한다.
    function addContent(
        bytes _contentKey,
        string _mainTitle,
        string _subTitle,
        string _description,
        string _recital
    ) public returns(bool) {
        uint256 _createdTime = block.timestamp;

        productItems[contentCount] = ContentData(_contentKey, 
        _mainTitle, 
        _subTitle, 
        _description,
        _recital,
        _createdTime
         );

        contentCount++;

        return true;
    }
    //@ TODO  : deleteContent 제어자 추개해야한다.
    function deleteContent(
        uint8 _num
    ) public returns (bool) {
        require(_num != 0, "fn:deleteContent - _num is 0");
        
        productItems[_num] = ContentData("","","","","",0);

        return true;
    }

    function setConfigure(string _title, string _description) public returns(bool) {
        
        productTitle = _title;
        productDescription = _description;
        
        emit SetConfigure(msg.sender, productTitle, productDescription);
    }
    /**
    * @dev invest 모듈에서 해당 값을 불러온다. 
     */ 
    function getInvestorsLength() public returns (uint256) {

    }
    /**
    * @dev purchase 모듈에서 해당 값을 불러온다.
     */
    function getPurchasersLength() public returns (uint256) {

    }

    /**
    * @ @dev 모듈 정보를 불러온다.
     */

    function getModule(uint8 _moduleType, uint8 _moduleIndex) public view returns (bytes32, address) {

    }
    
    // function addModule
    // function deleteModule
}
