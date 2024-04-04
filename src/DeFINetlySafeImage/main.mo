import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Blob "mo:base/Blob";
import D "mo:base/Debug";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import SimpleEncrypt "simpleEncrypt";
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


public query func getAdminIdentity(): async Text{
return ADMIN_INTERNET_IDENTITY;

};
    

    public query func  EnryptPassword(principalId:Text,passwordText:Text): async Text{

     let encryptedPasswordResult =   SimpleEncrypt.encryptPassword(principalId,passwordText);

    return encryptedPasswordResult;

    };

//remove principalId later on to make it secure you must get auto principal by msg.caller
        public query func  DecryptPassword(principalId:Text,encryptedText:Text): async Text{

     let decryptedPasswordResult =   SimpleEncrypt.decryptPassword(principalId,encryptedText);

    return decryptedPasswordResult;

    };

    public shared(msg)  func sendImage(imageReceiverId:Principal,image:Blob,isLocked:Bool,passwordHash:Text):async(){

         

            let callerId:Principal=msg.caller;
                //I can add  log system later on instead of Debug
            D.print(debug_show(Principal.toText(callerId) # " --- sending image to --- :" # Principal.toText(imageReceiverId)));

            //send image with password hash then compare it with getImage func dont EXPOSE IT'S HASH

             
  
            if(isLocked==true){
             
                   let encryptedPassword=await EnryptPassword(Principal.toText(callerId),passwordHash);
           var  newTransaction:Transaction = {sender=callerId;receiver=imageReceiverId;image=image;isLocked=true;passwordHash=encryptedPassword};
           
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
                             D.print("not locked photo sending from:" # debug_show(Principal.toText(callerId))# "to :" # debug_show(Principal.toText(imageReceiverId)));
                       var  newTransaction:Transaction = {sender=callerId;receiver=imageReceiverId;image=image;isLocked=false;passwordHash=""};
 userTransactions.put(callerId,[newTransaction]);
           await debugUserTransaction();

           return;
                }
                
             




            //islocked true end block
            }
  


        else{

          
         
               
           var  newTransaction:Transaction = {sender=callerId;receiver=imageReceiverId;image=image;isLocked=false;passwordHash=""};
           
          let isHaveTransactionHistoryResult:Bool= await isHaveTransactionHistory(callerId);
              if(isHaveTransactionHistoryResult==true){


                    switch(userTransactions.get(callerId)){

                        case (null) {return};
                        case (?transactionHistory)
                        {
                            let updatedTransactionHistory=Array.append<Transaction>(transactionHistory,[newTransaction]);

                            userTransactions.put(callerId,updatedTransactionHistory);

                            return;
                        }

                   

                    }

                                
   
             
                     }
                      
//if there is no transaction in history between these related users
                else{
                             D.print("there is no transaction in history between these related users :" # debug_show(Principal.toText(callerId))# "to :" # debug_show(Principal.toText(imageReceiverId)));
                       var  newTransaction:Transaction = {sender=callerId;receiver=imageReceiverId;image=image;isLocked=false;passwordHash=""};
 userTransactions.put(callerId,[newTransaction]);
           await debugUserTransaction();

           return;


                }
     

        };
        //print state after insert operation

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

    //photo Index Id eklenicek bu sayede if Array.size(transactionHistory) < photoIndexId olanlar sırayla
    //galleri şeklinde tek tek node'daki imageler alınacak sonrasında
    public shared(msg) func receiveImage(senderId:Principal,receiverId:Principal,isLocked:Bool,password:Text):async Blob{
   
   
   let emptyBlob = "" : Blob;
            let isHaveTransactionHistoryResult =  await isHaveTransactionHistory(senderId);
           if(isHaveTransactionHistoryResult){


                       switch(userTransactions.get(senderId)){

                        case (null) {return emptyBlob};
                        case (?resultTransactionArray)
                        {
                             var transactionHistory:[Transaction] =  resultTransactionArray;
                       
                            
                           
                            if(isLocked==true){
                                
                                let senderIdText=Principal.toText(senderId);

                            let encryptedPasswordParam= await EnryptPassword(senderIdText,password);

                            //for now use will only access last image but i will make it iterable
                            //so user can see all photos in gallery on frontend
                                let lastElementIndex:Nat=Array.size(transactionHistory)-1;


                              let encryptedPassword =  transactionHistory[lastElementIndex].passwordHash;

                              if(encryptedPasswordParam==encryptedPassword){

                                    D.print("Password is correct -- Locked Element receiving by :"#debug_show(receiverId)
                                    #" Last Element :"# debug_show(transactionHistory[lastElementIndex])
                                    );
                                    return  transactionHistory[lastElementIndex].image;

                                    
                              }
                              
                              else{

                                    // i can add msg.caller to frequency list to mark he/she as suspect attacker
                                    //after many different incorrect password trys
                                    //or maybe users also should be pay very small fees to get their photos also
                                   D.print("Password is incorrect : "#debug_show(msg.caller));

                                   return emptyBlob;
                              }
                                        

                            }

                            //if image is not locked

                            else{
                                      let lastElementIndex=Array.size(transactionHistory)-1;
                                        let isNodeElementLockedInBlockChain =  transactionHistory[lastElementIndex].isLocked;
                                
                                if(isNodeElementLockedInBlockChain==true){
                                           D.print("Node Element Locked :"#debug_show(msg.caller));
                                        return emptyBlob;
                                };
                             

                                         D.print("Image Element receiving by :"#debug_show(receiverId)
                                    #"Last Element"# debug_show(transactionHistory[lastElementIndex])
                                    );
                                      return  transactionHistory[lastElementIndex].image;
                            }
                        }
                       }

      
           };

   return emptyBlob;
    };

};
