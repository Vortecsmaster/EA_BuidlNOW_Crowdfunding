utxo="2d25336ac4a28ad3ba3250680610aaabc0d7f8122793d2dc72d2c36f65db58b7#1"
script_utxo="a9857306b6b7c5b5713268870638a545d5308d060f670ced23882f96d034c10a#0"
script_address=$(cat ../compiled/crowdf01.addr)
output_campaign="2000000"
output_backer="110000000"
creatorPKH=$(cat $HOME/Dev/Wallets/Adr08.pkh)
collateralPKH=$(cat $HOME/Dev/Wallets/Adr07.pkh)
collateral="4cbf990857530696a12b0062546a4b123ad0bef21c67562e32d03e3288bdcd7b#0"
Adr08=$(cat $HOME/Dev/Wallets/Adr08.addr)

cardano-cli conway transaction build \
  $PREVIEW \
  --tx-in $script_utxo \
  --tx-in-script-file ../compiled/crowdf01.uplc \
  --tx-in-inline-datum-present \
  --tx-in-redeemer-file ../values/cfredeemer.json \
  --tx-in $utxo \
  --required-signer-hash $creatorPKH \
  --tx-in-collateral $collateral \
  --tx-out $script_address+$output_campaign \
  --tx-out-inline-datum-file ../values/cfdatum_change1.json \
  --tx-out $script_address+$output_backer \
  --tx-out-inline-datum-file ../values/cfdatum_backer.json \
  --change-address $nami3 \
  --out-file cancel_campaign.unsigned

cardano-cli conway transaction sign \
    --tx-body-file cancel_campaign.unsigned \
    --signing-key-file $HOME/Dev/Wallets/Bob.skey \
    --signing-key-file $HOME/Dev/Wallets/Adr08.skey \
    --signing-key-file $HOME/Dev/Wallets/Adr07.skey \
    $PREVIEW \
    --out-file cancel_campaign.signed

cardano-cli conway transaction submit \
    $PREVIEW \
    --tx-file cancel_campaign.signed
