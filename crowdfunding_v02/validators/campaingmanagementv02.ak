//// Less holes, a few obvious optimizations are evident.

use aiken/collection/list
use aiken/crypto.{VerificationKeyHash}
use aiken/interval.{Finite}
use cardano/transaction.{OutputReference, Transaction, ValidityRange}

pub type CFdatum {
  Campaign {
    campaign_id: Int,
    title: ByteArray,
    goal: Int,
    creator: ByteArray,
    backer: ByteArray,
    deadline: Int,
    current_funds: Int,
  }

  Backer { campaign_id: Int, backer: ByteArray }
}

/// Optimization -> Change to enumerator style Int -> Action
/// 0 -> Cancel
/// 1 -> Update
/// 2 -> Close
pub type Action =
  Int

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
      0 ->
        cancel_campaign(
          data,
          redeemer.campaign_id,
          transaction.extra_signatories,
          transaction.validity_range,
        )

      1 ->
        update_campaign(
          data,
          redeemer.campaign_id,
          transaction.extra_signatories,
        )

      2 ->
        claims(
          data,
          redeemer.campaign_id,
          transaction.extra_signatories,
          transaction.validity_range,
        )

      _ -> False
    }
  }

  else(_) {
    fail
  }
}

/// Cancellation conditions
///   done ->  Datum.campaignId == Redeemer.campaignId
///   done ->  Datum.creator => Authorize transaction by signingn it.
///   done ->  Datum.current_funds == 0
///   todo ->  Datum.deadline > transaction.validRange.upperbound
fn cancel_campaign(
  datum: CFdatum,
  campaign: Int,
  signatories: List<VerificationKeyHash>,
  validrange: ValidityRange,
) -> Bool {
  expect Campaign { campaign_id, current_funds, creator, deadline, .. } = datum
  // Optimization: Use the *and* function for impoving readability of logical operation chain. 
  and {
    campaign_id == campaign,
    current_funds == 0,
    must_be_signed_by(creator, signatories),
    must_happen_before(validrange, deadline),
  }
}

/// Update conditions
///   Datum.campaignId == Redeemer.campaignId
///   Datum.backer => Authorize his support by signingn the transaction.
///   Datum.backer /= Datum.creator
fn update_campaign(
  datum: CFdatum,
  campaign: Int,
  signatories: List<VerificationKeyHash>,
) -> Bool {
  expect Campaign { campaign_id, backer, .. } = datum
  // Optimization: Use the *and* function for impoving readability of logical operation chain. 
  and {
    campaign_id == campaign,
    must_be_signed_by(backer, signatories),
  }
}

/// Claims conditions
///   done -> Datum.campaignId == Redeemer.campaignId
///   done -> Datum.current_funds >= Datum.goal
///   done -> Datum.backer == Redeemer.backer
///   done -> Datum.creator => Authorize transaction by signingn it.
///   todo -> Datum.deadline < transaction.validRange.lowerbound    
fn claims(
  datum: CFdatum,
  campaign: Int,
  signatories: List<VerificationKeyHash>,
  validrange: ValidityRange,
) -> Bool {
  expect Campaign { campaign_id, current_funds, goal, creator, deadline, .. } =
    datum
  // Optimization: Use the *and* function for impoving readability of logical operation chain. 
  and {
    campaign_id == campaign,
    current_funds >= goal,
    must_be_signed_by(creator, signatories),
    must_happen_after(validrange, deadline),
  }
}

fn must_be_signed_by(
  verification_key_hash: ByteArray,
  signatories: List<VerificationKeyHash>,
) -> Bool {
  // The verificationKeyHash is the hash of the verification key of the signature

  signatories |> list.has(verification_key_hash)
}

// Introduce Piping for better readability

fn must_happen_after(range: ValidityRange, tx_expiration_time: Int) {
  when range.lower_bound.bound_type is {
    Finite(tx_latest_time) -> tx_expiration_time < tx_latest_time
    _ -> False
  }
}

fn must_happen_before(range: ValidityRange, tx_expiration_time: Int) {
  when range.upper_bound.bound_type is {
    Finite(tx_latest_time) -> tx_expiration_time > tx_latest_time
    _ -> False
  }
}
