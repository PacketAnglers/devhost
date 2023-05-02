while true
do
  echo Ping Check VRF B Hosts...
  fping -f /usr/local/bin/ip_list_vrf_b
  sleep 2
  clear
done
