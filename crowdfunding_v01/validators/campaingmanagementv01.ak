//// This contract is like swiss cheese, full of holes.

use aiken/collection/list
use aiken/crypto.{VerificationKeyHash}
use cardano/transaction.{OutputReference, Transaction}

/// Why not Strings?
pub type CFdatum {
  campaign_id: Int,
  title: ByteArray,
  goal: Int,
  creator: ByteArray,
  backer: ByteArray,
  deadline: Int,
  current_funds: Int,
}

/// shorthand notation for custom types
/// the full version would have the explicit Data Constructor like
/// type Datum { Datum {...fields are the same as above...} }
pub type Action {
  Cancel
  Update
  Close
}

/// multiple data constructors
pub type CFredeemer {
  campaign_id: Int,
  action: Action,
  amount: Int,
  backer: ByteArray,
}

validator manage_campaign {
  spend(
    datum: Option<CFdatum>,
    redeemer: CFredeemer,
    _utxo: OutputReference,
    transaction: Transaction,
  ) {
    expect Some(data) = datum

    when redeemer.action is {
      Cancel ->
        cancel_campaign(
          data,
          redeemer.campaign_id,
          transaction.extra_signatories,
        )

      Update ->
        update_campaign(
          data,
          redeemer.campaign_id,
          transaction.extra_signatories,
        )

      Close -> claims(data, redeemer.campaign_id, transaction.extra_signatories)
    }
  }

  else(_) {
    fail
  }
}

/// Cancellation conditions
///    Datum.campaignId == Redeemer.campaignId
///    Datum.creator => Authorize transaction by signingn it.
///    Datum.current_funds == 0
fn cancel_campaign(
  datum: CFdatum,
  campaign_id: Int,
  signatories: List<VerificationKeyHash>,
) -> Bool {
  and {
    datum.campaign_id == campaign_id,
    datum.current_funds == 0,
    must_be_signed_by(datum.creator, signatories),
  }
}

/// Update conditions
///    Datum.campaignId == Redeemer.campaignId
///    Datum.backer => Authorize his support by signingn the transaction.
fn update_campaign(
  datum: CFdatum,
  campaign_id: Int,
  signatories: List<VerificationKeyHash>,
) -> Bool {
  and {
    datum.campaign_id == campaign_id,
    must_be_signed_by(datum.backer, signatories),
  }
}

/// Claims conditions
///   Datum.campaignId == Redeemer.campaignId
///   Datum.current_funds >= Datum.goal
///   Datum.backer /= Datum.creator
///   Datum.creator => Authorize transaction by signingn it.
fn claims(
  datum: CFdatum,
  campaign_id: Int,
  signatories: List<VerificationKeyHash>,
) -> Bool {
  and {
    datum.campaign_id == campaign_id,
    datum.current_funds >= datum.goal,
    must_be_signed_by(datum.creator, signatories),
  }
}

fn must_be_signed_by(
  verification_key_hash: VerificationKeyHash,
  signatories: List<VerificationKeyHash>,
) -> Bool {
  // The verificationKeyHash is the hash of the verification key of the signature
  signatories |> list.has(verification_key_hash)
}
