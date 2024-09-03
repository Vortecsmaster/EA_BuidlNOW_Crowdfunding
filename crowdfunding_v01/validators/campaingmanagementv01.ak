use aiken/hash.{Hash, Blake2b_224,}
use aiken/list.{has}
use aiken/time.{PosixTime}
use aiken/transaction.{ScriptContext, }
use aiken/transaction/credential.{VerificationKey}

// Why not Strings?
type CFdatum {
    campaignId: Int,
    title: ByteArray,
    goal: Int,
    creator: ByteArray,
    backer: ByteArray,
    deadline: PosixTime,
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
            Update -> update_campaign(datum, redeemer.campaignId, scriptContext.transaction.extra_signatories)
            Close  -> claims(datum, redeemer.campaignId, scriptContext.transaction.extra_signatories )
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
//    Datum.backer => Authorize his support by signingn the transaction.
fn update_campaign(datum: CFdatum, campaignId: Int, signatories: List<Hash<Blake2b_224, VerificationKey>>) -> Bool {
    datum.campaignId == campaignId                               &&
    must_be_signed_by(datum.backer, signatories) 
}


// Claims conditions
//   Datum.campaignId == Redeemer.campaignId
//   Datum.current_funds >= Datum.goal
//   Datum.backer /= Datum.creator
//   Datum.creator => Authorize transaction by signingn it.

fn claims(datum: CFdatum, campaignId: Int, signatories: List<Hash<Blake2b_224, VerificationKey>>) -> Bool {
    datum.campaignId == campaignId                              &&
    datum.current_funds >= datum.goal                           &&
    must_be_signed_by(datum.creator, signatories)               
}

fn must_be_signed_by(verificationKeyHash: ByteArray, signatories: List<Hash<Blake2b_224, VerificationKey>>) -> Bool {
    // The verificationKeyHash is the hash of the verification key of the signature
   has(signatories, verificationKeyHash)
}


// This contract is like swiss cheese, full of holes.
