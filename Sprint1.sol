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

     
     
     function findNonce(int x,int y)public view returns(uint256,bytes32,uint256,uint256,uint256){

          int256 teamNo = pc_interface.getMyTeamNumber();
          bytes32 bytes32_TeamNo = bytes32(teamNo);

          bytes32  cellHash = pc_interface.getCellHash(x,y);
          uint256  pow = uint256(pc_interface.getCellPower(x,y));
          uint  nonce = 1; 
          bytes32  newHash = sha256(abi.encodePacked(cellHash,bytes32_TeamNo,nonce));

          uint  multiplication = uint(newHash)*(2**pow);
          bytes32  finalHash = bytes32(multiplication);

          uint256 int_cellHash = uint256(cellHash);
          uint256 int_newHash = uint256(newHash);

          if(int_cellHash > int_newHash){
               while(int_cellHash > int_newHash){
               int_newHash = uint256(sha256(abi.encodePacked(cellHash,bytes32_TeamNo,nonce)));

               nonce++;
               }

               //Nonce was returning one more than needed because of condition. So its one decreased here after loop.
               nonce--;
          }
          
               return (nonce,bytes32(nonce),int_cellHash,int_newHash,pow);
          } 

}