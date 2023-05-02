while true
do
  echo Ping Check VRF A Hosts...
  fping -f /usr/local/bin/ip_list_vrf_a
  sleep 2
  clear
done
