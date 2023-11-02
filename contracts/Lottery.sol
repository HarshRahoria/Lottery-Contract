//SPDX-License-Identifier: UNLICENSED
pragma solidity >0.8.0 <=0.9.0;

contract Lottery{
    address payable public winner;
    struct particiapnt{
         uint id;
         address payable accountAddress;
    }

    mapping(uint=>particiapnt) ParticipantsList;

    address public manager;

    uint private nextID;
    modifier onlyManager(){
        require(msg.sender == manager, "You are not allowed to do this functionality!");
        _;
    }

    constructor(){
        manager = msg.sender;
    }

    function registerParticipant() public payable {
        require(msg.sender != manager, "You are manager");
        require(msg.value == 1 ether, "Enter valid ticket size");
        ParticipantsList[nextID] = particiapnt(nextID, payable (msg.sender));
        nextID++;
    }

    function getBalanceOfBallot() public view onlyManager returns(uint){
        require(msg.sender == manager, "You are not manager");
        return(address(this).balance);
    }

    function random() private view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, nextID)));
    }

    function selectWinner() public onlyManager(){
        
        require(nextID>= 3);
        uint index = random() % nextID;
        winner = ParticipantsList[index].accountAddress;
        winner.transfer(address(this).balance);
        for(uint i=0; i<nextID; i++){
            ParticipantsList[i] = particiapnt(0,payable(address(0)));
        }
        nextID = 0;
    }

    function returnParticipantsList() public view returns (particiapnt[] memory){
        particiapnt[] memory participantsList = new particiapnt[](nextID);
        particiapnt memory temp;
        for(uint i=0; i<nextID; i++){
            temp = ParticipantsList[i];
            participantsList[i] = temp;
        }
        return participantsList;
    }

    receive() external payable{
        if(msg.value != 1 ether || msg.sender != manager){
            payable (msg.sender).transfer(msg.value);
        }
        ParticipantsList[nextID] = particiapnt(nextID, payable (msg.sender));
        nextID++;
    }
    fallback() external { }
}