import {Blockfrost, Lucid,LucidEvolution, SpendingValidator, fromHex, Credential, credentialToAddress, applyDoubleCborEncoding, validatorToAddress } from "npm:@lucid-evolution/lucid";
//import * as cbor from "https://deno.land/x/cbor@v1.4.1/index.js";
//import test01_signingKey from "/home/cardano/Dev/Wallets/Adr11skey.json" with {type: 'json'};
import {network} from "./settings.ts"

const project_path = "/home/cardano/Dev/CREOW/crowdfunding_v02";

const lucid = await Lucid(new Blockfrost("https://cardano-preview.blockfrost.io/api/v0", Deno.env.get("BLOCKFROST_PROJECT_ID"),),network);


// Construct address from credentials and import keys.

const paymentCredential: Credential = {
    type: "Key",
    hash: "2070f8488dd696b78a5f23e38d273550e43660526c4b19cba733b488"  //taken from cardano-cli generated verification key hash
};

const stakeCredential: Credential = {
      type: "Key",
      hash: "8662fe85a22159022d71aebcf4342bcafaa6ede0df2e486a4e751e8e" // taken from cardano-cli generated stake verification key hash
  };
const bob_address = credentialToAddress(network, paymentCredential, stakeCredential);
console.log("Address11:  " + bob_address);


//read validator from blueprint json file created with aiken

 const validator = await readValidator();

 async function readValidator(): Promise<SpendingValidator> {
    const validator = JSON.parse(await Deno.readTextFile("/home/cardano/Dev/EA_DIY_Crowdfunding/crowdfunding_v01/plutus.json")).validators[0];
   return {
    type: "PlutusV3",
    script: applyDoubleCborEncoding(validator.compiledCode)
  };
}

const campaignsAddress = validatorToAddress(network, validator,); 


console.log(campaignsAddress);

// Create a campaign
// const campaign = async (): Promise<Result<TxComplete>> => { 
//   try {
  
//     if (!lucid) throw "Uninitialized Lucid";
//     if (!bob_address) throw "Non defnied address";
    
//     const tx = await lucid
//       .newTx()
//       .payToContract(<validator_addr>,<inline: datum>,<assets>)

//     console.log("TODO BIEN!")
//   }
//   catch (error) {
//     console.log("Error: " + error);
//     if (error instanceof Error) return { type: "error", error: error };
//     return { type: "error", error: new Error(`${JSON.stringify(error)}`) };
//   }
// }