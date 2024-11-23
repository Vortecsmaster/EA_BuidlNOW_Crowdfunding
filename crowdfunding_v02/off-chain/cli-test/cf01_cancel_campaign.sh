utxo="78a1e9cc56066af82f373b78b7fd2d4d9b7e513c439afa6c626ca35507db3c8a#2"
script_utxo="7d55eebf00ffde1e9bd5b6f34c939936adb50030fccd7c6f1fec9332ab123b8d#0"
script_address=$(cat ../compiled/crowdf01.addr)
output="2000000"
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
  --tx-out $nami3+$output \
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
