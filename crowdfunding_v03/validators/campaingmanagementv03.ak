use aiken/transaction.{ScriptContext}


//part of the explanation of valiator functions with their correspdoning datum, redeemer and scriptcontext.
type Datum {
    title: String,
    description: String,
    goal: Int,
    creator: String, //Address
    campaignId: Int,
    deadline: Int
    current_fund: Int
} 

// shorthand notation for single data constructor custom types
// the full version would have the explicit Data Constructor like
// type Datum { Datum {...fields are the same as above...} }

type Action {
    Update
    Close
}
// multiple data constructors

type Redeemer {
    action: Action,
    amount: Int,
    campaignId: Int,
    donor: String //Address
}

validator {
    fn manage_campaign(_datum: Datum, redeemer: Redeemer, _scriptContext: ScriptContext) -> Bool {
        when redeemer.action is {
            Update -> update_campaign()
            Claim  -> proposer_claim()
        }
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