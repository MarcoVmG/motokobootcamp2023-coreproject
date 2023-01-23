export const idlFactory = ({ IDL }) => {
  const Votes = IDL.Record({ 'votes_true' : IDL.Nat, 'votes_false' : IDL.Nat });
  const Proposal = IDL.Record({
    'proposalText' : IDL.Text,
    'userPrincipal' : IDL.Principal,
    'proposalVotes' : Votes,
  });
  return IDL.Service({
    'delete_proposal' : IDL.Func([IDL.Nat], [], ['oneway']),
    'get_all_proposals' : IDL.Func(
        [],
        [IDL.Vec(IDL.Tuple(IDL.Nat, Proposal))],
        ['query'],
      ),
    'get_proposal' : IDL.Func([IDL.Nat], [IDL.Opt(Proposal)], ['query']),
    'submit_proposal' : IDL.Func([Proposal], [], []),
    'vote' : IDL.Func([IDL.Nat, IDL.Bool, IDL.Principal], [IDL.Text], []),
  });
};
export const init = ({ IDL }) => { return []; };
