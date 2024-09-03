use aiken/hash.{Hash, Blake2b_224,}
use aiken/interval.{Finite}
use aiken/list.{has}
use aiken/time.{PosixTime}
use aiken/transaction.{ScriptContext, ValidityRange}
use aiken/transaction/credential.{VerificationKey}


type CFdatum {
    Campaign {
    campaignId: Int,
    title: ByteArray,
    goal: Int,
    creator: ByteArray,
    backer: ByteArray,
    deadline: PosixTime,
    current_funds: Int
    }
    Backer {
    campaignId: Int,
    backer: ByteArray
    }
} 

//Optimization -> Change to enumerator style Int -> Action
type Action = Int
// 0 -> Cancel
//   1 -> Update
//   2 -> Close

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
            0 -> cancel_campaign(datum,redeemer.campaignId, scriptContext.transaction.extra_signatories, scriptContext.transaction.validity_range)
            1 -> update_campaign(datum, redeemer.campaignId, scriptContext.transaction.extra_signatories)
            2  -> claims(datum, redeemer.campaignId, scriptContext.transaction.extra_signatories, scriptContext.transaction.validity_range)
            _ -> False
       }
    }
}
// Cancellation conditions
//   done ->  Datum.campaignId == Redeemer.campaignId
//   done ->  Datum.creator => Authorize transaction by signingn it.
//   done ->  Datum.current_funds == 0
//   todo ->  Datum.deadline > transaction.validRange.upperbound

fn cancel_campaign(datum: CFdatum, campaign: Int, signatories: List<Hash<Blake2b_224, VerificationKey>>, validrange: ValidityRange) -> Bool {
    expect Campaign {campaignId, title, goal, creator, backer, deadline, current_funds} = datum  
         campaignId == campaign                                             &&
         current_funds == 0                                                 &&
         must_be_signed_by(creator, signatories)                            &&
         must_happen_before(validrange, deadline)                     
}

// Update conditions
//    Datum.campaignId == Redeemer.campaignId
//    Datum.backer => Authorize his support by signingn the transaction.
fn update_campaign(datum: CFdatum, campaignId: Int, signatories: List<Hash<Blake2b_224, VerificationKey>>) -> Bool {
    datum.campaignId == campaignId                               &&
    must_be_signed_by(datum.backer, signatories) 
}


// Claims conditions
//   done -> Datum.campaignId == Redeemer.campaignId
//   done -> Datum.current_funds >= Datum.goal
//   done -> Datum.backer == Redeemer.backer
//   done -> Datum.creator => Authorize transaction by signingn it.
//   todo -> Datum.deadline < transaction.validRange.lowerbound
    
fn claims(datum: CFdatum, campaignId: Int, signatories: List<Hash<Blake2b_224, VerificationKey>>, validrange: ValidityRange) -> Bool {
    datum.campaignId == campaignId                              &&    
    datum.current_funds >= datum.goal                           &&
    must_be_signed_by(datum.creator, signatories)               &&
    must_happen_after(validrange, datum.deadline)               
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

fn must_happen_before(range: ValidityRange, tx_expiration_time: PosixTime) {
  when range.upper_bound.bound_type is {
    Finite(tx_latest_time) -> tx_expiration_time > tx_latest_time
    _ -> False
  }


}

// Less holes, a few obvious optimizations are evident.