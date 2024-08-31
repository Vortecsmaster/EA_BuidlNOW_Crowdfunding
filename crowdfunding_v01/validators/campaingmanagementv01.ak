use aiken/transaction.{ScriptContext}
use aiken/transaction/credential.{VerificationKey}
use aiken/list.{has}
use aiken/hash.{Hash, Blake2b_224,}

//Why not Strings?
type CFdatum {
    campaignId: Int,
    title: ByteArray,
    goal: Int,
    creator: ByteArray,
    backer: ByteArray,
    deadline: Int,
    current_funds: Int
} 

// shorthand notation for custom types
// the full version would have the explicit Data Constructor like
// type Datum { Datum {...fields are the same as above...} }

type Action {
    Cancel
    Update
    Close
}
// multiple data constructors

type CFredeemer {
    campaignId: Int,
    action: Action,
    amount: Int,    
    backer: ByteArray
}

validator {
    fn manage_campaign(datum: CFdatum, redeemer: CFredeemer, scriptContext: ScriptContext) -> Bool {
        when redeemer.action is {
            Cancel -> cancel_campaign(datum,redeemer.campaignId, scriptContext.transaction.extra_signatories)
            Update -> update_campaign()
            Close  -> claims()
       }
    }
}
// Cancellation conditions
//    Datum.campaignId == Redeemer.campaignId
//    Datum.creator => Authorize transaction by signingn it.
//    Datum.current_funds == 0
fn cancel_campaign(datum: CFdatum, campaignId: Int, signatories: List<Hash<Blake2b_224, VerificationKey>>) -> Bool {
    datum.campaignId == campaignId                               &&
    datum.current_funds == 0                                     &&
    must_be_signed_by(datum.creator, signatories) 
}

// Update conditions
//    Datum.campaignId == Redeemer.campaignId
//    Datum.backer => Authorize transaction by signingn it.

fn update_campaign() -> Bool {
    True
}

fn claims() -> Bool {
    // The datum is 
    // The redeemer is 
    // The scriptContext is the context of the transaction
    // The function should return a boolean value
    True
}

fn must_be_signed_by(verificationKeyHash: ByteArray, signatories: List<Hash<Blake2b_224, VerificationKey>>) -> Bool {
    // The verificationKeyHash is the hash of the verification key of the signature
   has(signatories, verificationKeyHash)
}


// First explanations:
//     functions
//     primitives types
//     custom types
//     validators
//     imports (use)