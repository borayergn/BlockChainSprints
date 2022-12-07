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
     function captureCell(int x, int y , uint mode,uint limit) payable public returns(bytes32){

          require(mode == 1 || mode == 0,"Invalid mode");
          PowerContractInterface pc_interface = PowerContractInterface(powerContractAddres);

          (,bytes32 nonce,,,) = findNonce(x,y);

       
          if(mode == 0) {
               (,nonce,,,) = findNonce(x,y);
          }
          else{
               (,nonce,,,) = findPowerfullNonce(x,y,limit);
          }        
          

          bytes32 newHash = pc_interface.setCellsFromContract.value(0.1 ether)(x,y,nonce);

          return newHash;
     }        

     //Functions to be written for increasing functionality with sending one request for taking multiple cells.

     function captureRow(int row,uint mode,uint limit) payable public{
          require(mode == 1 || mode == 0,"Invalid Mode");

          PowerContractInterface pc_interface = PowerContractInterface(powerContractAddres);
          bytes32 nonce;
          for(int256 i = 0 ; i < pc_interface.getXdimension(); i++){
                      
               if(mode == 0) {
                    (,nonce,,,) = findNonce(row,i);
               }
               else{
                    (,nonce,,,) = findPowerfullNonce(row,i,limit);
               }   

               pc_interface.setCellsFromContract.value(0.1 ether)(row,i,nonce);

          }
     }

     function captureColumn(int column,uint mode , uint limit) payable public{
          require(mode == 1 || mode == 0,"Invalid Mode");

          PowerContractInterface pc_interface = PowerContractInterface(powerContractAddres);
          bytes32 nonce;
          for(int256 i = 0 ; i < pc_interface.getYdimension(); i++){
                      
               if(mode == 0) {
                    (,nonce,,,) = findNonce(i,column);
               }
               else{
                    (,nonce,,,) = findPowerfullNonce(i,column,limit);
               }   

               pc_interface.setCellsFromContract.value(0.1 ether)(i,column,nonce);

          }
     }

     //Only available for ordinary capture
     function captureSquare(int startPointX , int startPointY,int sideLength) payable public{

          PowerContractInterface pc_interface = PowerContractInterface(powerContractAddres);

          require(
          (startPointX+sideLength) < pc_interface.getXdimension() || (startPointY+sideLength) < pc_interface.getYdimension()
          ,"Square is out of range."
          );

          bytes32 nonce;
          for(int i = startPointX; i < (startPointX+sideLength) ; i++){
               for(int j = startPointY; j < (startPointY+sideLength) ; j++){
                    (,nonce,,,) = findNonce(i,j);
                    pc_interface.setCellsFromContract.value(0.1 ether)(i,j,nonce);
               }
          }
     }

     //Function to get more stronger nonce number to make the cell more unrecapturable.
     function findPowerfullNonce(int x , int y,uint256 limit) public view returns(uint256,bytes32,bytes32,bytes32,uint256){
          PowerContractInterface pc_interface = PowerContractInterface(powerContractAddres);
          int256 teamNo = pc_interface.getMyTeamNumber();
          bytes32 bytes32_TeamNo = bytes32(teamNo);

          bytes32  cellHash = pc_interface.getCellHash(x,y);
          uint256  pow = uint256(pc_interface.getCellPower(x,y));
          uint  nonce = 1; 

          uint256 counter = 0;
          bytes32 finalHash;
          uint256 multiplication;
                   
          while(counter < limit){
          finalHash = sha256(abi.encodePacked(cellHash,bytes32_TeamNo,nonce));
          multiplication = uint(finalHash)*(2**pow);
          finalHash = bytes32(multiplication);
          nonce++;
          if(cellHash<finalHash){
               counter++;
               }              
          }
          nonce--;
         
          return (nonce,bytes32(nonce),cellHash,finalHash,pow);        
     }

    
     //TODO: Finish this function
     function showCellOwners() public view returns(int256[] memory){
          PowerContractInterface pc_interface = PowerContractInterface(powerContractAddres);
          int256 currentTeam;
          int256[] memory teamsArr;
          uint256 index = 0;
          for(int256 i = 0; i < pc_interface.getXdimension();i++){
               for(int256 j = 0; j < pc_interface.getYdimension();j++){
                    currentTeam = pc_interface.getCellTeamNumber(i,j);
                    teamsArr[index] = currentTeam;
               }
          }
          return teamsArr;
     }
     
}
