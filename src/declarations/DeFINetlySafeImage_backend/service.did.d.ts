import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export interface _SERVICE {
  'DecryptPassword' : ActorMethod<[string, string], string>,
  'EnryptPassword' : ActorMethod<[string, string], string>,
  'debugUserTransaction' : ActorMethod<[], undefined>,
  'getAdminIdentity' : ActorMethod<[], string>,
  'isHaveTransactionHistory' : ActorMethod<[Principal], boolean>,
  'payTransactionFee' : ActorMethod<[], boolean>,
  'receiveImage' : ActorMethod<
    [Principal, Principal, boolean, string],
    Uint8Array | number[]
  >,
  'sendImage' : ActorMethod<
    [Principal, Uint8Array | number[], boolean, string],
    undefined
  >,
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
