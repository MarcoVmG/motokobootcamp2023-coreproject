import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import Text "mo:base/Text";

actor {

//Proposal definition
    type Proposal = {
        userPrincipal : Principal;
        proposalText : Text;
        proposalVotes : Votes
    }; 
//Votes type definition

    type Votes = {
        votes_true : Nat;
        votes_false : Nat
    };
    var proposals = HashMap.HashMap<Nat, Proposal>(1, Nat.equal, Hash.hash);

    stable var proposalCount : Nat = 0;

// Create proposal
    public func submit_proposal(proposal : Proposal) : async () {

        let id : Nat = proposalCount;
        proposalCount += 1;

        proposals.put(id, proposal)
    };

// Read proposal
    public query func get_proposal(id : Nat) : async ?Proposal {

        let proposalRes : ?Proposal = proposals.get(id);

        proposalRes
    };
//Read all proposals

    public query func get_all_proposals() : async [(Nat, Proposal)] {

        let proposalsIter : Iter.Iter<(Nat, Proposal)> = proposals.entries();

        let proposalsArray : [(Nat, Proposal)] = Iter.toArray(proposalsIter);

        proposalsArray;

    };

    // Update proposal
    private func update_proposal_votes(id : Nat, votes : Votes) : Text {

        let proposalRes : ?Proposal = proposals.get(id);

        switch (proposalRes) {
            case (null) {
                "Cannot complete operation, you are trying to updte a non-existent proposal."
            };
            case (?currentProposal) {

                let updateProposal : Proposal = {
                    userPrincipal = currentProposal.userPrincipal;
                    proposalText = currentProposal.proposalText;
                    proposalVotes = votes;

                };

                proposals.put(id, updateProposal);

                "Proposal updated succesfully"
            }
        }
    };

    //Delete proposal

    public func delete_proposal(id : Nat) :  () {

        let proposalRes : ?Proposal = proposals.get(id);

        switch (proposalRes) {
            case (null) {
                ();
            };
            case (_) {

                ignore proposals.remove(id);


            }
        }
    };

//Call canister MBT to check balance of the wallet

    private func balance_check(principal : Principal) : async Nat {

        let receiver : actor {
            icrc1_balance_of : ({ owner : Principal; subaccount : ?[Nat8] }) -> async Nat
        } = actor "db3eq-6iaaa-aaaah-abz6a-cai";

        let balance = await receiver.icrc1_balance_of({
            owner = principal;
            subaccount = null
        });

        return balance
    };


//Function for voting and aproove or reject proposals

    public func vote(proposal_id : Nat, vote : Bool, principal : Principal) : async Text {
        var vote_op : Text = "";
        let balance_Check = await balance_check(principal);
        let proposalRes : ?Proposal = proposals.get(proposal_id);

        switch (proposalRes) {

            case (null) {
                return "You are trying to vote an proposal that does not exist."
            };
            case (?proposalRes) {
                var votes = {
                    votes_true = proposalRes.proposalVotes.votes_true;
                    votes_false = proposalRes.proposalVotes.votes_false
                };
// If votes reach 100 to approve the proposal and another user votes to approve it will show a message and the text on the webpage will change
                if (votes.votes_true == 100) {
                    let webpage_text = change_webpage(proposalRes.proposalText);
                    return ("The proposal you trying to vote is been approved.");
// If votes reach 100 to reject the proposal and another user votes to reject it will show a message and the proposal will be deleted
                } else if (votes.votes_false == 100) {
                    let proposal_rejected = delete_proposal(proposal_id);
                    return ("The proposal you trying to vote is been rejected.");
                } else {
                    if (balance_Check >= 1) {
                        if (vote == true) {
                            vote_op := "Yes";
                            votes := {
                                votes_true = proposalRes.proposalVotes.votes_true + 1;
                                votes_false = proposalRes.proposalVotes.votes_false
                            };
                            var update_votes = update_proposal_votes(proposal_id, votes)
                        } else {
                            vote_op := "No";
                            votes := {
                                votes_true = proposalRes.proposalVotes.votes_true;
                                votes_false = proposalRes.proposalVotes.votes_false + 1
                            };
                            var update_votes = update_proposal_votes(proposal_id, votes)
                        };
                        return ("You voted " # vote_op # " to the proposal with Id " # Nat.toText(proposal_id))
                    } else {
                        return ("You dont have enough found to vote")
                    }
                };

            }
        }

    };

    //Adapt text webpage to approved proposal.

    private func change_webpage(webpage_text : Text) : async () {

        let receiver : actor { change_page_text : (page_text : Text) -> async () } = actor "5o3md-fiaaa-aaaan-qc25a-cai";

        let response = await receiver.change_page_text(webpage_text);
        return ();

    };

};
