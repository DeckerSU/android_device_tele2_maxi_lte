# Use this to add maxi_lte_tele2 to CM's lunch command menu
for var in eng user userdebug; do
  add_lunch_combo mk_maxi_lte-$var
done
