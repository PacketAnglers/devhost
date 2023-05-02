while true
do
  echo Ping Check VRF B Hosts...
  fping -f /usr/local/bin/iplist_vrf_b
  sleep 2
  clear
done
