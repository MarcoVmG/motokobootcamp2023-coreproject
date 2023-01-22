import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import Text "mo:base/Text";

actor {
    //My discord is: iri#1598

    //Proposal definition
    type Proposal = {
        userPrincipal : Principal;
        proposalText : Text;
        proposalVotes : Votes;
    }; // TO DEFINE;

    type Votes = {
        votes_true :Nat;
        votes_false : Nat;
    };
    var proposals = HashMap.HashMap<Nat, Proposal>(1, Nat.equal, Hash.hash);

    stable var proposalCount : Nat = 0;

    // Create proposal
    public func submit_proposal(proposal : Proposal) : async () {

        let id : Nat = proposalCount;
        proposalCount += 1;

        proposals.put(id, proposal);
    };

    // Read proposal
    public query func get_proposal(id : Nat) : async ?Proposal {

        let proposalRes : ?Proposal = proposals.get(id);

        proposalRes;
    };

    public query func get_all_proposals() : async [(Nat, Proposal)] {

        let proposalsIter : Iter.Iter<(Nat, Proposal)> = proposals.entries();

        let proposalsArray : [(Nat, Proposal)] = Iter.toArray(proposalsIter);

        proposalsArray;

    };

    // Update proposal
    private func update_proposal_votes( id : Nat, votes : Votes) :  Text {

        let proposalRes : ?Proposal = proposals.get(id);

        switch (proposalRes) {
            case (null) {
                "Cannot complete operation, you are trying to updte a non-existent proposal.";
            };
            case (?currentProposal) {

                let updateProposal : Proposal = {
                    userPrincipal = currentProposal.userPrincipal;
                    proposalText = currentProposal.proposalText;
                    proposalVotes = votes ;

                };

                proposals.put(id, updateProposal);

                "Proposal updated succesfully";
            }
        }
    };

    //Delete proposal

    public func delete_proposal(id : Nat) : async Text {

        let proposalRes : ?Proposal = proposals.get(id);

        switch (proposalRes) {
            case (null) {
                "Cannot complete operation, you are trying to delete a non-existent proposal.";
            };
            case (_) {

                ignore proposals.remove(id);

                "Proposal has been sucessfuly removed!";
            }
        }
    };

    //Call canister MBT

    

     private func balance_check(principal : Principal) :  Nat {
        // Working call
        /* let receiver : actor {icrc1_balance_of : ({ owner : Principal; subaccount : ?[Nat8] }) -> async Nat} = actor "db3eq-6iaaa-aaaah-abz6a-cai";

        let response = await receiver.icrc1_balance_of({owner = principal; subaccount = null}); */
        var balance : Nat =1000;
        return balance;
    };

    public func vote(proposal_id : Nat, vote : Bool, principal : Principal) : async Text {
        var vote_op : Text = "";
        let balance_Check = balance_check(principal);
        let proposalRes : ?Proposal = proposals.get(proposal_id);
        
        switch (proposalRes) {

            case (null) {
                return "You are trying to vote an proposal that does not exist.";
            };
            case (?proposalRes) {
                var votes = {votes_true = proposalRes.proposalVotes.votes_true; votes_false = proposalRes.proposalVotes.votes_false};

                if(votes.votes_true == 100 ){
                    let webpage_text = change_webpage(proposalRes.proposalText);
                    return ("The proposal you trying to vote is been approved.");
                }else if ( votes.votes_false == 100){
                    return ("The proposal you trying to vote is been rejected.")
                }else{
                    if (balance_Check >= 1) {
                    if (vote == true) {
                        vote_op := "Yes";
                        votes := {votes_true = proposalRes.proposalVotes.votes_true + 1; votes_false = proposalRes.proposalVotes.votes_false};
                         var update_votes = update_proposal_votes(proposal_id, votes);
                    } else {
                        vote_op := "No";
                        votes := {votes_true = proposalRes.proposalVotes.votes_true ; votes_false = proposalRes.proposalVotes.votes_false + 1};
                        var update_votes = update_proposal_votes(proposal_id, votes);
                    };
                    return ("You voted " # vote_op # " to the proposal with Id " # Nat.toText(proposal_id))
                } else {
                    return ("You dont have enough found to vote");
                };
                };

                
            }
        }

    };

//Adapt text webpage to approved proposal.

    private func change_webpage ( webpage_text : Text) : async(){
    
        let receiver : actor {change_page_text : (page_text : Text) ->  async ()} = actor "r7inp-6aaaa-aaaaa-aaabq-cai";

        let response =  await receiver.change_page_text( webpage_text);
        return ();

    };

    
}
