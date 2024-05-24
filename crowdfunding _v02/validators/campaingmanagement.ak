use aiken/transaction.{ScriptContext}


//part of the explanation of valiator functions with their correspdoning datum, redeemer and scriptcontext.
type Datum {
    title: String,
    description: String,
    goal: Int,
    creator: String, //Address
    campaignId: Int,
    deadline: Int
} 

// shorthand notation for custom types
// the full version would have the explicit Data Constructor like
// type Datum { Datum {...fields are the same as above...} }

type Action {
    Create
    Update
    Close
}


type Redeemer {
    action: Action,
    amount: Int,
    campaignId: Int,
    donor: String //Address
}

validator {
    fn manage_campaign(_datum: Datum, redeemer: Redeemer, _scriptContext: ScriptContext) -> Bool {
        when redeemer.action is {
            Create -> create_campaign()
            Update -> update_campaign()
            Close  -> close_campaign()
        }
    }
}


fn create_campaign() -> Bool {
    // The datum is 
    // The redeemer is 
    // The scriptContext is the context of the transaction
    // The function should return a boolean value
    True
} 

fn update_campaign() -> Bool {
    // The datum is 
    // The redeemer is 
    // The scriptContext is the context of the transaction
    // The function should return a boolean value
    True
}

fn close_campaign() -> Bool {
    // The datum is 
    // The redeemer is 
    // The scriptContext is the context of the transaction
    // The function should return a boolean value
    True
}


// First explanations:
//     functions
//     primitives types
//     custom types
//     validators
//     imports (use)