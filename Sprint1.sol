 pragma solidity ^0.5.17;
 import "hardhat/console.sol";


contract PowerContractInterface{

 function getCellHash(int256 x, int256 y) public view returns (bytes32);
 function getCellNonce(int256 x, int256 y) public view returns (bytes32);
 function getCellPower(int256 x, int256 y) public view returns (int256);
 function getCellTeamNumber(int256 x, int256 y) public view returns (int256);
 function getSprintNumber() public view returns (int256);
 function getXdimension() public view returns (int256);
 function getYdimension() public view returns (int256);
 function getTeamNumberFromAccount(address teamAccount) public view returns (int);
 function setMyTeamContract(address contractAddress) public;
 function getMyTeamContract() public view returns (address);
 function getMyTeamCount() public view returns (int);
 function getMyTeamCallCount() public view returns (int);
 function showCellTeamNumbers() public view returns (string memory);
 function getMyTeamNumber() public view returns (int);
 function showLeaderBoard() public view returns (string memory);
 function showLeaderBoard_Calls() public view returns (string memory);
 function getTxOrigin() public view returns (address);
 function setCellsFromContract(int x, int y, bytes32 nonce) public payable returns (bytes32);
 function getTotalCalls() public view returns (uint);
}
contract BaBoBa{

   address powerContractAddres = 0xA7c40D644bDB571F98D72A08AF2A1Fb4Ab4f24fe;
   address myAdd = 0x06D99001C37C88f996f629698c822F19dB68388D;
   PowerContractInterface pc_interface = PowerContractInterface(powerContractAddres);

   function arrangeContract() public returns(address){
        
        pc_interface.setMyTeamContract(myAdd); 
        address teamAddress = pc_interface.getMyTeamContract();
        return teamAddress;
   }

    function teamNumber() public view returns(int){
         int team_number = pc_interface.getMyTeamNumber();
         return team_number;
    }

    address public t_address =  arrangeContract();
   
}
