use aiken/hash.{Hash, Blake2b_224,}
use aiken/interval.{Finite}
use aiken/list.{has}
use aiken/time.{PosixTime}
use aiken/transaction.{ScriptContext, ValidityRange}
use aiken/transaction/credential.{VerificationKey}

//Why not Strings?
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
            Close  -> claims(datum, redeemer.campaignId, scriptContext.transaction.validity_range)
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
fn update_campaign(datum: CFdatum, campaignId: Int, signatories: List<Hash<Blake2b_224, VerificationKey>>) -> Bool {
    datum.campaignId == campaignId                               &&
    must_be_signed_by(datum.backer, signatories) 
}


// Claims conditions
//   *Datum.campaignId == Redeemer.campaignId
//   *Datum.deadline > scriptContext.transaction.validRange.upperbound
//   Datum.current_funds >= Datum.goal
//   Datum.backer == Redeemer.backer
//   Redeemer.backer = ""
//   Datum.creator => Authorize transaction by signingn it.

fn claims(datum: CFdatum, campaignId: Int, validrange: ValidityRange ) -> Bool {
    datum.campaignId == campaignId                               &&
    must_happen_after(validrange, datum.deadline)               &&
    True
}

fn must_be_signed_by(verificationKeyHash: ByteArray, signatories: List<Hash<Blake2b_224, VerificationKey>>) -> Bool {
    // The verificationKeyHash is the hash of the verification key of the signature
   has(signatories, verificationKeyHash)
}

fn must_happen_after(range: ValidityRange, tx_expiration_time: PosixTime) {
  when range.lower_bound.bound_type is {
    Finite(tx_latest_time) -> tx_expiration_time < tx_latest_time
    _ -> False
  }
}

// First explanations:
//      functions
//      primitives types
//      type alias
//      custom types
//      validators
//      imports (use)
