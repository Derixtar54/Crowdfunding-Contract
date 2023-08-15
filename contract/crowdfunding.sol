
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract Vote{
address public electioncommision;
address public winner;
struct Voter{
    string name;
    uint age;
    uint voterId;
    string gender;
    uint voteCandidateId;
    address voterAddress;
}
struct Candidate{
    string name;
    string party;
    uint age;
    string gender;
    uint candidateId;
    address candidateAddress;
    uint votes;
}
uint nextVoterId = 1;
uint nextCandidateId =1;
uint startTime;
uint endTime;
mapping(uint=>Voter)voterDetails;
mapping(uint=>Candidate)candidateDetails;
bool stopVoting;
constructor()
{
electioncommision  = msg.sender;
}
function candidateRegister(string memory calldata_name,string memory calldata_party,uint _age,
string memory  calldata_gender) public {
    require(msg.sender!= electioncommision,"You are from election commssion");
    require(candidateVerification(msg.sender),"You have already registered");
    require(_age >= 18,"You re below 18");
    require(nextCandidateId <3,"Registration full");
    candidateDetails[nextCandidateId] = Candidate(calldata_name, calldata_party, _age, calldata_gender,nextCandidateId,msg.sender,0);
    nextCandidateId++;
}
function candidateVerification(address _person)internal view returns(bool){
    for(uint i=1 ; i<nextCandidateId;i++){
        if(candidateDetails[i].candidateAddress == _person){
            return false;
        }
    }
    return true;
}
function candidateList() public view returns(Candidate[] memory){
    Candidate[] memory arr = new Candidate[](nextCandidateId-1);
    for(uint i=1 ; i<nextCandidateId;i++){
        arr[i-1] = candidateDetails[i];
    }
    return arr;
}
function voterRegister(string calldata_name,uint _age, string calldata _gender)external{
    require(voterVerification(msg.sender),"You have already registrated");
    require(_age>=18,"You are not eligible to vote");
    voterDetails[nextVoterId] = Voter( _name  ,_age,nextVoterId, _gender,0,msg.sender);
    nextVoterId++;
}
function voterVerification(address _user)internal view returns(bool){
    for(uint i=1; i<nextVoterId; i++){
        if(voterDetails[i].voterAddress == _user){
            if(voterDetails[i].voterAddress == _user){
                return false;
            }
        }
        return true;
    }
function voterList() public view returns(Voter[] memory)
{  voter[] memory arr = new Voter[](nextVoterId-1);
    for(uint i =1 ; i<nextVoterId ; i++){
        arr[i-1] = voterDetails[i];
    }
    return arr;
}
function vote(uint _voterId,uint _id) external isVotingOver(){
    require(voterDetails[_voterId].voteCandidateId == 0,"You have already voted");
    require(voterDetails[_voterId].voterAddress == msg.sender, " You are not registered");
    require(block.timestamp >startTime, "Voting has not started");
    require(nextCandidate >2 , "Candidate registration is not done yet");
    require(_id >0 && _id <3,"Candidate does not exist");
    voterDetails[_voterId].voteCandidateId = _id;
    candidateDetails[_id].votes++;
}
function voteTime(uint _startTime , uint _endTime) external {
    require(electionCommission == msg.sender," You are not from election commission");
    startTime = block.timestamp+ _startTime;
    endTime = startTime+ _endTime;
    stopVoting = false;
}
function votingStatus() external view returns(string memory){
    if(startTime == 0){
        return "Voting Not Started";
    }
    else if(startTime!= 0 && endTime >block.timestamp) && stopVoting == false){
        return "Voting in progress";
    }else
    {
        return "Voting ended";
    }
    }
    function result () external {
        require(electionCommission == msg.sender, "You are not from election commission");
        Candidate[] memory arr = new Candidate[](nextCandidateId-1);
        arr = candidateList();
        if(arr[0].votes > arr[1].votes){
            winner = arr[0].candidateAddress;
        }else{
            winner = arr[1].candidateAddress;
        }
    }
    function emergency() public{
        require(electionCommision == msg.sender,"You are not from election commsion");
        stopVoting = true;
    }
    modifier is VotingOver(){
        require(endTime > block.timestamp || stopVoting, "Voting is over");
        _;
    }
}
}



