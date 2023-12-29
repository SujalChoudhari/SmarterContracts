// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "template.sol";

/// @title Decentralized Voting System
/// @dev Smart contract for creating and participating in decentralized polls.
contract VotingSystem is Template {
    enum PollStatus { Active, Closed }

    struct Poll {
        uint256 id;
        string question;
        string[] options;
        mapping(address => uint256) votes; // Voter's address to option index
        PollStatus status;
    }

    mapping(uint256 => Poll) public polls;
    uint256 public pollCount = 0;

    event PollCreated(uint256 pollId, string question, string[] options);
    event VoteCasted(uint256 pollId, address voter, uint256 optionIndex);
    event PollClosed(uint256 pollId);

    // CREATE POLL
    function createPoll(string memory _question, string[] memory _options)
        public
        onlyOwner
    {
        require(_options.length >= 2, "At least two options required");

        pollCount++;
        Poll storage newPoll = polls[pollCount];
        newPoll.id = pollCount;
        newPoll.question = _question;
        newPoll.options = _options;
        newPoll.status = PollStatus.Active;

        emit PollCreated(pollCount, _question, _options);
    }

    // CAST VOTE
    function castVote(uint256 _pollId, uint256 _optionIndex) public onlyCustomer {
        Poll storage poll = polls[_pollId];
        require(poll.status == PollStatus.Active, "Poll is closed");

        require(
            _optionIndex < poll.options.length,
            "Invalid option index"
        );

        poll.votes[msg.sender] = _optionIndex;

        emit VoteCasted(_pollId, msg.sender, _optionIndex);
    }

    // CLOSE POLL
    function closePoll(uint256 _pollId) public onlyOwner {
        Poll storage poll = polls[_pollId];
        require(poll.status == PollStatus.Active, "Poll is already closed");

        poll.status = PollStatus.Closed;

        emit PollClosed(_pollId);
    }
}
