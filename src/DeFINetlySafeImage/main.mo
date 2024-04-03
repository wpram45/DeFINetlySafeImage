import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Blob "mo:base/Blob";
import D "mo:base/Debug";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
actor ImageTransactionTracker {



    let ADMIN_INTERNET_IDENTITY:Text="2361744";

    // Transaction type will be amend later on
    type Transaction = {
        sender: Principal;
        receiver: Principal;
        image: Blob;
        //if sender define password to unlock image
        isLocked:Bool;

        passwordHash:Text;

    };

    // main HashMap to store our user Transaction
    var userTransactions : HashMap.HashMap<Principal, [Transaction]> = HashMap.HashMap<Principal, [Transaction]>((0, Principal.equal, Principal.hash));



    public query func isHaveTransactionHistory(sender:Principal):async Bool{
      switch (userTransactions.get(sender)) {
        case (null) { return false; };
        case (?transactionHistory) { return Array.size(transactionHistory) != 0; };
    };
    };


    public shared(msg)  func sendImage(imageReceiverId:Principal,image:Blob,isLocked:Bool,passwordHash:Text):async(){

         

            let callerId:Principal=msg.caller;
                //I can add  log system later on instead of Debug
            D.print(debug_show(Principal.toText(callerId) # " --- sending image to --- :" # Principal.toText(imageReceiverId)));

            //send image with password hash then compare it with getImage func dont EXPOSE IT'S HASH

             
  
            if(isLocked==true){
           var  newTransaction:Transaction = {sender=callerId;receiver=imageReceiverId;image=image;isLocked=true;passwordHash=passwordHash};
           
          let isHaveTransactionHistoryResult:Bool= await isHaveTransactionHistory(callerId);
              if(isHaveTransactionHistoryResult==true){


                    switch(userTransactions.get(callerId)){

                        case (null) {return};
                        case (?transactionHistory)
                        {
                            let updatedTransactionHistory=Array.append<Transaction>(transactionHistory,[newTransaction]);

                            userTransactions.put(callerId,updatedTransactionHistory);
                        }

                    }


             
                     }

                //if there is no transaction in history between these related users
                else{
                 userTransactions.put(msg.caller,[newTransaction]);
           
           
                     }





            //islocked true end block
            }
  


        else{

         
        await debugUserTransaction();

        };

            //if there is a transaction before get old transaction add their end

          

    };


    public func payTransactionFee():async Bool {
        //we wil add transaction fee mechanism  [icp-token] here later on 
        // use ADMIN_INTERNET_IDENTITY
        return true;
    };

    public query func debugUserTransaction():async(){


        let entries=Iter.toArray(userTransactions.entries());
        D.print(debug_show("userTransaction : " , entries))

    };

};
