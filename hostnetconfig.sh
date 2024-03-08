bond=false

while [ "$1" != "" ]; do
    case $1 in
        -b | --bond )
            bond=true;;
        -i4 | --ip4 )
            ip4=$2
            shift;;
        -i6 | --ip6 )
            ip6=$2
            shift;;
        -g | --gateway )
            gw=$2
            shift;;
        -m | --mgmtnet )
            mgmtnet=$2
            shift;;
        --)
            break;;
        *)
            printf "Unknown Option %s\n" "$1"
            exit 1
    esac
    shift
done

if $bond ; then

    ifconfig eth1 down
    ifconfig eth2 down

    ip link add bond0 type bond mode 802.3ad

    ip link set eth1 master bond0
    ip link set eth2 master bond0

    ifconfig bond0 up

    ip addr add $ip4 dev bond0
    ip -6 addr add $ip6 dev bond0
    route add -net 10.0.0.0/8 dev bond0 gw $gw
    route add -net 224.0.0.0 netmask 240.0.0.0 gw $gw bond0

    if  [ -n "$mgmtnet" ]; then
        route add -net $mgmtnet dev eth0 gw 172.100.100.1
    fi

else

    ip addr add $ip4 dev eth1
    ip -6 addr add $ip6 dev eth1
    ifconfig eth1 up
    route add -net 10.0.0.0/8 dev eth1 gw $gw
    route add -net 224.0.0.0 netmask 240.0.0.0 gw $gw eth1

    if [ -n "$mgmtnet" ]; then
        route add -net $mgmtnet dev eth0 gw 172.100.100.1
    fi

fi
