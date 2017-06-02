pragma solidity ^0.4.6;

contract vote {
  mapping ( bytes32=> uint8) public votesReceived;
  bytes32[] public canList;

  function voting(bytes32[] names) {
    canList=names;
  }

  function totalVotersFor(bytes32 name) returns(uint8){
    if (vaildCandidate(name)==false) throw;
    return votesReceived[name];
  }

  function voteForCandidate(bytes32 name) {
    if (vaildCandidate(name)==false) throw;
    votesReceived[name]+=1;
  }
  function vaildCandidate(bytes32 name) returns (bool) {
    for(uint i=0;i<canList.length;i++){
      if(canList[i]==name){
        return true;
      }
    }
    return  false;
  }
}
