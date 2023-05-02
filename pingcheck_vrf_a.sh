while true
do
  echo Ping Check VRF A Hosts...
  fping -f /usr/local/bin/iplist_vrf_a
  sleep 2
  clear
done
