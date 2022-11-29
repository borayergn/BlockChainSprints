pragma solidity ^0.5.17;


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
     

     function arrangeContract() public returns(address){
          
          PowerContractInterface pc_interface = PowerContractInterface(powerContractAddres);
          pc_interface.setMyTeamContract(msg.sender); 
          address teamAddress = pc_interface.getMyTeamContract();
          return teamAddress;
     }

     function teamNumber() public view returns(int){
          PowerContractInterface pc_interface = PowerContractInterface(powerContractAddres);
          int team_number = pc_interface.getMyTeamNumber();
          return team_number;
     }

     address public t_address =  arrangeContract();

     
     
     function findNonce(int x,int y)public view returns(uint256,bytes32,bytes32,bytes32,uint256){

          PowerContractInterface pc_interface = PowerContractInterface(powerContractAddres);
          int256 teamNo = pc_interface.getMyTeamNumber();
          bytes32 bytes32_TeamNo = bytes32(teamNo);

          bytes32  cellHash = pc_interface.getCellHash(x,y);
          uint256  pow = uint256(pc_interface.getCellPower(x,y));
          uint  nonce = 1; 
          bytes32  newHash = sha256(abi.encodePacked(cellHash,bytes32_TeamNo,nonce));

          uint  multiplication = uint(newHash)*(2**pow);
          bytes32  finalHash = bytes32(multiplication);


          if(cellHash > finalHash){
               while(cellHash > finalHash){
               finalHash = sha256(abi.encodePacked(cellHash,bytes32_TeamNo,nonce));
               multiplication = uint(finalHash)*(2**pow);
               finalHash = bytes32(multiplication);

               nonce++;
                    }

               //Nonce was returning one more than needed because of condition. So its one decreased here after loop.
               nonce--;
               }
          
               return (nonce,bytes32(nonce),cellHash,finalHash,pow);
          } 


     //To use this function on VMs other functions that interacts with power contract should be commented.
     /*
     function VM_Test_FindNonce(bytes32 hashOfCell,uint256 power) view public returns(uint256,bytes32,uint256,uint256,uint256){

          int256 teamNo = 5;
          bytes32 bytes32_TeamNo = bytes32(teamNo);

          bytes32  cellHash = hashOfCell;
          uint256  pow = power;
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
     */

     //Mode parameter is for choosing which mode(function to call) to choose
     //1 = Finding a powerfull nonce which will be hard to recapture
     //0 = will be the ordinary next valid nonce
     function captureCell(int x, int y , uint mode) payable public returns(bytes32){

          PowerContractInterface pc_interface = PowerContractInterface(powerContractAddres);

          (,bytes32 nonce,,,) = findNonce(x,y);

          /*
          ---------------------------
          Mode logic will be written
          ---------------------------
          if(mode == 0) {
               (,nonce,,,) = findNonce(x,y);
          }
          else{
               (,nonce,,,) = findPowerfullNonce(x,y);
          }        
          */

          bytes32 newHash = pc_interface.setCellsFromContract.value(0.1 ether)(x,y,nonce);

          return newHash;
     }        

     //Functions to be written for increasing functionality with sending one request for taking multiple cells.
     function takeRow(int row) payable public{

     }

     function takeColumn(int column) payable public{

     }
     function takeSquare(int sideLength , int startPoint) payable public{
          
     }

     //Function to be written to get more stronger nonce number to make the cell more unrecapturable.
     function findPowerfullNonce(int x , int y) payable public returns(uint256,bytes32,bytes32,bytes32,uint256){
          
     }


}

