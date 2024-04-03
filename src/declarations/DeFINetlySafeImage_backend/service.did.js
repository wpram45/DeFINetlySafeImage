export const idlFactory = ({ IDL }) => {
  return IDL.Service({
    'debugUserTransaction' : IDL.Func([], [], ['query']),
    'isHaveTransactionHistory' : IDL.Func(
        [IDL.Principal],
        [IDL.Bool],
        ['query'],
      ),
    'payTransactionFee' : IDL.Func([], [IDL.Bool], []),
    'sendImage' : IDL.Func(
        [IDL.Principal, IDL.Vec(IDL.Nat8), IDL.Bool, IDL.Text],
        [],
        [],
      ),
  });
};
export const init = ({ IDL }) => { return []; };
