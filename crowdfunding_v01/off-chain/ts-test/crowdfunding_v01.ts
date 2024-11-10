import {Blockfrost, Lucid,LucidEvolution, SpendingValidator, fromHex, Credential, credentialToAddress, applyDoubleCborEncoding } from "npm:@lucid-evolution/lucid";
//import * as cbor from "https://deno.land/x/cbor@v1.4.1/index.js";
//import test01_signingKey from "/home/cardano/Dev/Wallets/Adr11skey.json" with {type: 'json'};
import {network} from "./settings.ts"

const project_path = "/home/cardano/Dev/CREOW/crowdfunding_v02";

// const network = "Preview";

const lucid = await Lucid(new Blockfrost("https://cardano-preview.blockfrost.io/api/v0", Deno.env.get("BLOCKFROST_PROJECT_ID"),),network);

const paymentCredential: Credential = {
    type: "Key",
    hash: "2070f8488dd696b78a5f23e38d273550e43660526c4b19cba733b488"  //taken from cardano-cli generated verification key hash
};

const stakeCredential: Credential = {
      type: "Key",
      hash: "8662fe85a22159022d71aebcf4342bcafaa6ede0df2e486a4e751e8e" // taken from cardano-cli generated stake verification key hash
  };
const address11 = credentialToAddress(network,paymentCredential, stakeCredential);
console.log("Address11:  " + address11);


//await Deno.writeTextFile("/home/cardano/Dev/Wallets/Adr11.addr", address11);
// Alternative, generate new private keys with Lucid
//  const ourPrivateKey = lucid.utils.generatePrivateKey();
//  await Deno.writeTextFile("OurAddress.skey", ourPrivateKey);
//Cardano Private key in bech32; not the BIP32 private key or any key that is not fully derived. 
// * Only an Enteprise address (without stake credential) is derived.

// const address11 = await lucid
//    .selectWalletFromPrivateKey(test01_signingKey.ed25519)  
//    .credentialToAddress(paymentCredential, stakeCredential)
//    .wallet.address();

//read validator from blueprint json file created with aiken

 const validator = await readValidator();

 async function readValidator(): Promise<SpendingValidator> {
    const validator = JSON.parse(await Deno.readTextFile("/home/cardano/Dev/EA_DIY_Crowdfunding/crowdfunding_v01/plutus.json")).validators[0];
   return {
    type: "PlutusV3",
    script: applyDoubleCborEncoding(validator.compiledCode)
  };
}

console.log(validator);