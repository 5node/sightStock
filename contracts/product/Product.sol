pragma solidity >=0.4.24;

import "../interface/InterfaceProduct.sol";


/**
*
*
*		
 */
 
contract Product is InterfaceProduct {
    
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

    

}
