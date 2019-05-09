pragma solidity >=0.4.24;

import "./InterfaceModule.sol";

/**
* @dev 기초 투자 인터페이스 ( 투자자를 위한 )
*
* 
* 
* 
 */

contract InterfaceInvestModule is InterfaceModule {
    
    function getNumberInvestors() public view returns (uint256);
    
}