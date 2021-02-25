// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

contract Ballot {

    // most likely the owner of this contract
    address public chairperson;

    // this declares a new complex type for a single voter
    struct Voter {
        uint weight; // how much power their vote has
        bool voted; // did the voter vote? 
        address delegate; // person delegated to
        uint vote; // index of the voted proposal
    }

    // Hash table that keys each address to a Voter variable. 
    mapping(address => Voter) public voters;

    // this is a type for a single proposal
    struct Proposal {
        bytes32 name; // short name of proposal (up to 32 bytes)
        uint voteCount; // how many votes did this proposal receive? 
    }

    // A dyanmically-sized array of Proposal typed variables
    Proposal[] public proposals;

    // Create a new ballot to choose one of 'proposalNames'
    constructor(bytes32[] memory proposalNames) {
        // upon construction of this contract, the chairperson will 
        // be assigned to whoever created this contract.
        chairperson = msg.sender;
        // assign chairperson's address to a Voter struct and declare
        // their voteCount = 0.
        voters[chairperson].weight = 1;

        // For each proposal name, push a new Proposal type into the
        // the end of the proposals array while assigning it with  
        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0 
            }));
        }
    }

    // Give the voter a right to vote in this ballot. 
    // Only the chairperson can do this.
    function giveRightToVote(address voter) public {
        // if the first argument of require evaluates to false,
        // then the execution terminates and all changes and Ether
        // balances are reverted.
        // It is a good idea to use 'require' to check if functions
        // are called correctly.
        require(
            msg.sender == chairperson, 
            "Only the chairperson can give the right to vote"
        );
        // Did the voter not vote?
        require(
            !voters[voter].voted,
            "The voter already voted."
        );
        // Does the voter have no weight in voting?
        require(
            voters[voter].weight == 0,
            "The voter already has a weight in voting"
        );
        // If all requires pass, give the voter a weight to vote.
        voters[voter].weight = 1;
    }

    /// Delegate your vote to voter `to`.
    function delegate(address to) public {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "You already voted.");
        require (to != msg.sender, "Self-delegation isn't allowed.");

        // dangerous loop. can run for a while and use up a ton of gas. 
        // Sometimes causing a contract to get stuck completely
        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;
            require(to != msg.sender, "Self-delegation not allowed!");
        }

        // since `sender` is a reference, this modifies
        // voters[msg.sender] voted
        sender.voted = true;
        sender.delegate = to;

        // Create a delegate from the address `to`
        Voter storage _delegate = voters[to];
        if (_delegate.voted) {
            // If the delegate already voted, directly add to the number
            // of votes
            proposals[_delegate.vote].voteCount += sender.weight;
        } else {
            // If the delegate did not vote, add to her weight.
            _delegate.weight += sender.weight;
        }
    }

    /// Give your vote (including the votes delegated to you) to a proposal
    function vote(uint proposal) public {
        // Create a new reference value to whomever called this  
        // function externally.
        Voter storage sender = voters[msg.sender];

        // Does the sender have weight?
        require(sender.weight != 0, "Has no right to vote");
        // Has the sender already voted? 
        require(!sender.voted, "Already voted");
        sender.voted = true;
        sender.vote = proposal;
        // If `proposal` is out of the range of the array, this 
        // will automatically throw and revert all changes!
        proposals[proposal].voteCount += sender.weight;
    }

    /// Computes the winning proposal by taking all previous votes into account;
    function winningProposal() public view returns (uint _winningProposal) {
        uint winningVoteCount = 0;
        for (uint i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                _winningProposal = i;
            }
        }
    }

    function winnerName() public view returns (bytes32 _winnerName) {
        _winnerName = proposals[winningProposal()].name;
    }
}