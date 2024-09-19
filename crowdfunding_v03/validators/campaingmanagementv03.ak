//// part of the explanation of validator functions with their correspdoning datum, redeemer and scriptcontext.

use cardano/transaction.{OutputReference, Transaction}
use crowdfunding_v03/types.{Claim, Datum, Redeemer, Update}

validator manage_campaign {
  spend(
    _datum: Option<Datum>,
    redeemer: Redeemer,
    _utxo: OutputReference,
    _transaction: Transaction,
  ) {
    when redeemer.action is {
      Update -> update_campaign()
      Claim -> proposer_claim()
      _ -> False
    }
  }

  else(_) {
    fail
  }
}

fn update_campaign() -> Bool {
  // The output datum should not the same as the input datum.
  // The output datum should be strictly sent back only to the same scriptAddress 
  // The datum goal can be updated, only if the datum.current_fund is 0
  True
}

fn proposer_claim() -> Bool {
  // The input datum.current_fund must be equal or greater thatn the datum.goal
  // The total value of the inputs of the transaction must be EQUAL to datum.current_funds 
  // All the value from the inputs must go to the proporsers address
  // The transaction must be signed by the proposer.
  // The input datum.deadline must have been reached.
  // step2 - The output value will include some token as prize or POAP
  True
}
// Explanations:
//     step1 - Count the crowfund in the form a token instead of the datum
//      topics 
//          - native tokens
//          - token value bundle
//          - forward minting policy design pattern
//     
//     step2 - Add an NFT as prize/POAP to the proposers
//      topics
//          - NFTs
//          - Parametrized validators 
