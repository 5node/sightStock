pragma solidity >=0.4.24;

import "../interface/interfaceProduct.sol";


/**
* 부모 컨트랙트		
1. 크리에이터 설정이 가능하다. onlyAdmin		
2. 크리에이터는 작품 컨트랙트를 만들 수 있다. onlyCreater   		
3. 크리에이터 판별 여부 함수를 보유한다. public		
4. (투자자 / 구매자) 상태 내역 저장할 것인가?		
 */
 
contract Product is interfaceProduct {
  
}
