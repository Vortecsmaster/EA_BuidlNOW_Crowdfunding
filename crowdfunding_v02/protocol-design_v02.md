### TX 1 - Create a Campaing 
Inputs:
  - Enough ADA to cover tx fees

Outputs:
  -UTxO with Crowdfunding Campaing Information (CFdatum)

Conditions:
  - There must be a datum that contains the campaing information.
- 
### TX 2 - Cancel Campaign
Inputs:
  - Tx fees
  - UTxO with Crowdfunding Campaing Information (CFdatum) -to be consumed.

Outputs:
 - Any remaining value back to campaing creator.  

Conditions:
 - CFdatum.current_funds must be 0.
 - CFdatum.campaignId == Redeemer.campaignId
 - CFdatum.creator => Authorize transaction by signing it.

### TX 3 - Support a Campaign 
Inputs:
  - UTxO with Crowdfunding Campaing Information (CFdatum).
  - UTxO with Support Value + tx fees.

Outputs:
  - UTxO with updated Crowdfunding Campaing Information (CFdatum)
  - UTxO with Support Value and corresponding CFdatum for support UTxO
  - 
Conditions:
  - CFRedeemer include the supporter and amount.
  - Support Value must be provided as input value among the non-script input UTxOs.
  - CFDatum.current_funds must be equal to its input value plus the defined support value (CFredeemer.ammount). 


### TX 4 - 
Inputs:
- 
Outputs:
  - 

Conditions:
  - 

### TX 5 - 
Inputs:
  -

Outputs:
  -
 
Conditions:
  - 