import { Lucid } from "https://deno.land/x/lucid@0.8.3/mod.ts";
import test01_signingKey from "../../../Wallets/Adr11skey.json" with {type: 'json'};e
const lucid = await Lucid.new(undefined, "Preview");
 
// Alternative, generate new private keys with Lucid
// const ourPrivateKey = lucid.utils.generatePrivateKey();
// await Deno.writeTextFile("OurAddress.skey", ourPrivateKey);
 
const address11 = await lucid
  .selectWalletFromPrivateKey(test01_signingKey.cborHex)
  .wallet.address();
await Deno.writeTextFile("our.addr", address11);
 
// const beneficiaryPrivateKey = lucid.utils.generatePrivateKey();
// await Deno.writeTextFile("beneficiary.sk", beneficiaryPrivateKey);
 
// const beneficiaryAddress = await lucid
//   .selectWalletFromPrivateKey(beneficiaryPrivateKey)
//   .wallet.address();
// await Deno.writeTextFile("beneficiary.addr", beneficiaryAddress);