import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export interface Proposal {
  'proposalText' : string,
  'userPrincipal' : Principal,
  'proposalVotes' : Votes,
}
export interface Votes { 'votes_true' : bigint, 'votes_false' : bigint }
export interface _SERVICE {
  'delete_proposal' : ActorMethod<[bigint], undefined>,
  'get_all_proposals' : ActorMethod<[], Array<[bigint, Proposal]>>,
  'get_proposal' : ActorMethod<[bigint], [] | [Proposal]>,
  'submit_proposal' : ActorMethod<[Proposal], undefined>,
  'vote' : ActorMethod<[bigint, boolean, Principal], string>,
}
