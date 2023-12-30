// SPDX-License-Identifier: MIT
pragma solidity >0.6.0 <0.9.0;
import "template.sol";

contract Election is Template {
    address[] public participatingCandidates;

    mapping(address => address) public votesCasted;
    mapping(address => uint256) internal votesCount;

    constructor() Template() {}

    function _isCandidate(address person) private view returns (bool) {
        for (uint256 i = 0; i < participatingCandidates.length; i++) {
            if (participatingCandidates[i] == person) {
                return true;
            }
        }
        return false;
    }

    function participate()
        public
        payable
        onlyCustomer
    onlyFixedAmount(5 ether)
    {
        participatingCandidates.push(msg.sender);
    }

    function vote(address candidate)
        public
        payable
        onlyCustomer
    onlyEnoughBalance(1 ether)
    {
        require(msg.sender != candidate, "Cannot vote self");
        require(_isCandidate(candidate), "Person is not Participating");

        votesCasted[msg.sender] = candidate;
        votesCount[candidate]++;
    }

    function getResults(address candidate)
        public
        view
        onlyOwner
        returns (uint256)
    {
        return votesCount[candidate];
    }
}
