### TX 1 - Create a Campaing 
Inputs:
- Enough ADA to cover create campaign tx fees and claims (goal not reached) tx fees.
- Minting Policy validator authorize the forge of Campaign ID token.
  
Outputs:
- UTxO with Crowdfunding Campaing Information.

Conditions:
- There must be a datum that contains the campaing information.
- The creation of the Campaign ID token requires the signature of the Campaign creator.
 
### TX 2 - Cancel Campaign
Inputs:
- Tx fees
- UTxO with Crowdfunding Campaing Information and Campaign token  -to be consumed.

Outputs:
- Any remaining value back to campaing creator.  


Conditions:
- Datum.current_funds must be 0.
- Datum.campaignId == Redeemer.campaignId
- Datum.creator => Authorize transaction by signing it.
- Datum.creator => Authorize burning Campaign NFT token by signing it.
- Campaign token must be burned.

#### TX 3 - Support a Campaign 
Inputs:
- UTxO with Crowdfunding Campaing Information.
- UTxO with Support Value + Tx fees.

Outputs:
- UTxO with Crowdfunding Campaign Information 
- UTxO with Support Value and corresponding datum for support UTxO
 
Conditions:
- Redeemer include the supporter and amount.
- Support Value must be provided as input value among the non-script input UTxOs.
- Datum.current_funds must be equal to its input value plus the defined support value (CFredeemer.ammount).

### TX 4 - Claims - Goal reach
Inputs:
- UTxO with crowdfunding campaing information.
- All UTxOs with Campaign Datum Id and backers support value.
- UTxO with Tx fees

Outputs:
- All value goes to crowdfunding campaign creator. 


### TX 5 - Claims - Goal not reach
Inputs:
-

Outputs:
-
 
Conditions:
- 