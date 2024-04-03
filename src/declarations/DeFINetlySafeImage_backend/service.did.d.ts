import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export interface _SERVICE {
  'debugUserTransaction' : ActorMethod<[], undefined>,
  'isHaveTransactionHistory' : ActorMethod<[Principal], boolean>,
  'payTransactionFee' : ActorMethod<[], boolean>,
  'sendImage' : ActorMethod<
    [Principal, Uint8Array | number[], boolean, string],
    undefined
  >,
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
