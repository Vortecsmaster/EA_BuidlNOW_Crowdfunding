

validator {
    fn campaignfunding(redeemer: Redeemer, scriptContext: ScriptContext) -> Bool {
        when redeemer.action is {
            Create  -> create_campaign()
            Support -> supporter_add_funds()
            Claim   -> proposer_claim()
        }
    }
}

fn create_campaing() -> Bool {
    // The output datum should be strictly sent back only to the same scriptAddress.
    // The datum goal can be updated, only if the datum.current_fund is 0.
    // The transaction must be signed by the proposer.
    True
}

fn supporter_add_funds() -> Bool {
    // The total value of the inputs in ADA should be equal to the minted value of the fundToken + fees. 
    // All the value from the inputs must go to the proporsers address.
    // The transaction must be signed by the supporter.
    // The input datum.deadline must have been reached.
    True
}

fn proposer_claim() -> Bool {
    // The input value of fundToken must be equal or greater thatn the datum.goal.
    // The total value of fundToken of the transaction must be EQUAL to datum.current_funds.
    // All the ADA value from the inputs must go to the proporsers address.
    // NFTs must go to the supporters.
    // The transaction must be signed by the proposer.
    // The input datum.deadline must have been reached.
    True
}