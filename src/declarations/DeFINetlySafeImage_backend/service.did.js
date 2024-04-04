export const idlFactory = ({ IDL }) => {
  return IDL.Service({
    'DecryptPassword' : IDL.Func([IDL.Text, IDL.Text], [IDL.Text], ['query']),
    'EnryptPassword' : IDL.Func([IDL.Text, IDL.Text], [IDL.Text], ['query']),
    'debugUserTransaction' : IDL.Func([], [], ['query']),
    'getAdminIdentity' : IDL.Func([], [IDL.Text], ['query']),
    'isHaveTransactionHistory' : IDL.Func(
        [IDL.Principal],
        [IDL.Bool],
        ['query'],
      ),
    'payTransactionFee' : IDL.Func([], [IDL.Bool], []),
    'receiveImage' : IDL.Func(
        [IDL.Principal, IDL.Principal, IDL.Bool, IDL.Text],
        [IDL.Vec(IDL.Nat8)],
        [],
      ),
    'sendImage' : IDL.Func(
        [IDL.Principal, IDL.Vec(IDL.Nat8), IDL.Bool, IDL.Text],
        [],
        [],
      ),
  });
};
export const init = ({ IDL }) => { return []; };
