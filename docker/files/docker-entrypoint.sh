#!/bin/sh

# Global variables
MODE_MASTER="master"
MODE_SHADOW="shadow"
MODE_METALOGGER="metalogger"
MODE_CHUNKSERVER="chunkserver"
MODE_CGISERVER="cgiserver"
MODE_SHELL="shell"
MASTER=${MASTER:-"192.168.0.100"}
EXPORTS_IP_CLASS=${EXPORTS_IP_CLASS:-"192.168.0.100/24"}
MFSMASTER_CONFIG="/etc/lizardfs/mfsmaster.cfg"
MFSSHADOW_CONFIG="/etc/lizardfs/mfsshadow.cfg"
MFSMETALOGGER_CONFIG="/etc/lizardfs/mfsmetalogger.cfg"
MFSCHUNKSERVER_CONFIG="/etc/lizardfs/mfschunkserver.cfg"
MFSEXPORTS_CONFIG="/etc/lizardfs/mfsexports.cfg"
MFSHDD_CONFIG="/etc/lizardfs/mfshdd.cfg"
GLOBALIOLIMITS_CONFIG="/etc/lizardfs/globaliolimits.cfg" 
MFSTOPOLOGY_CONFIG="/etc/lizardfs/mfstopology.cfg"
MFSGOALS_CONFIG="/etc/lizardfs/mfsgoals.cfg"
METADATA_MFS="/var/lib/lizardfs/metadata.mfs"

# Start logger
chmod a+rw /dev/stdout
rsyslogd

# Generate missing files
if [ "$1" = "$MODE_MASTER" ]; then
    if [ ! -f $MFSMASTER_CONFIG ]; then 
        echo "Generating $MFSMASTER_CONFIG"

        touch $MFSMASTER_CONFIG

        echo "MASTER_HOST=$MASTER" >> $MFSMASTER_CONFIG
        echo "PERSONALITY=master" >> $MFSMASTER_CONFIG
    fi

    if [ ! -f $MFSEXPORTS_CONFIG ]; then 
        echo "Generating $MFSEXPORTS_CONFIG"

        touch $MFSEXPORTS_CONFIG

        echo "*                       /       rw,alldirs,maproot=0,ignoregid" >> $MFSEXPORTS_CONFIG
        echo "*                       .       rw" >> $MFSEXPORTS_CONFIG
        echo "$EXPORTS_IP_CLASS          /       rw,alldirs,maproot=0" >> $MFSEXPORTS_CONFIG
    fi

    if [ ! -f $GLOBALIOLIMITS_CONFIG ]; then 
        echo "Generating $GLOBALIOLIMITS_CONFIG"

        touch $GLOBALIOLIMITS_CONFIG
    fi

    if [ ! -f $MFSTOPOLOGY_CONFIG ]; then 
        echo "Generating $MFSTOPOLOGY_CONFIG"

        touch $MFSTOPOLOGY_CONFIG
    fi

    if [ ! -f $MFSGOALS_CONFIG ]; then 
        echo "Generating $MFSGOALS_CONFIG"

        touch $MFSGOALS_CONFIG

        echo "1 1 : _" >> $MFSGOALS_CONFIG
        echo "2 2 : _ _" >> $MFSGOALS_CONFIG
        echo "3 3 : _ _ _" >> $MFSGOALS_CONFIG
        echo "4 4 : _ _ _ _" >> $MFSGOALS_CONFIG
        echo "5 5 : _ _ _ _ _" >> $MFSGOALS_CONFIG
    fi

    if [ ! -f $METADATA_MFS ]; then 
        echo "Generating $METADATA_MFS"

        touch $METADATA_MFS

        echo -n "MFSM NEW" >> $METADATA_MFS
    fi
fi

if [ "$1" = "$MODE_SHADOW" ]; then
    if [ ! -f $MFSSHADOW_CONFIG ]; then 
        echo "Generating $MFSSHADOW_CONFIG"

        touch $MFSSHADOW_CONFIG

        echo "MASTER_HOST=$MASTER" >> $MFSSHADOW_CONFIG
        echo "PERSONALITY=shadow" >> $MFSSHADOW_CONFIG
    fi
fi

if [ "$1" = "$MODE_METALOGGER" ]; then
    if [ ! -f $MFSMETALOGGER_CONFIG ]; then 
        echo "Generating $MFSMETALOGGER_CONFIG"

        touch $MFSMETALOGGER_CONFIG

        echo "MASTER_HOST=$MASTER" >> $MFSMETALOGGER_CONFIG
    fi
fi

if [ "$1" = "$MODE_CHUNKSERVER" ]; then
    if [ ! -f $MFSCHUNKSERVER_CONFIG ]; then 
        echo "Generating $MFSCHUNKSERVER_CONFIG"

        touch $MFSCHUNKSERVER_CONFIG

        echo "MASTER_HOST=$MASTER" >> $MFSCHUNKSERVER_CONFIG
    fi

    if [ ! -f $MFSHDD_CONFIG ]; then 
        echo "Generating $MFSHDD_CONFIG"

        touch $MFSHDD_CONFIG

        echo "/var/lib/lizardfs/chunk" >> $MFSHDD_CONFIG
    fi
fi


# Update files ownership
chown -R lizardfs:lizardfs /etc/lizardfs/
chown -R lizardfs:lizardfs /var/lib/lizardfs/

# Run the right daemon or program
if [ "$1" = "$MODE_MASTER" ]; then
    echo "Starting master"

    mfsmaster -d start

elif [ "$1" = "$MODE_SHADOW" ]; then
    echo "Starting shadow"

    mfsmaster -c /etc/lizardfs/mfsshadow.cfg -d start

elif [ "$1" = "$MODE_METALOGGER" ]; then
    echo "Starting metalogger"

    mfsmetalogger -d start

elif [ "$1" = "$MODE_CHUNKSERVER" ]; then
    echo "Starting chunkserver"

    mfschunkserver -d start

elif [ "$1" = "$MODE_CGISERVER" ]; then
    echo "Starting cgiserver"

    lizardfs-cgiserver

elif [ "$1" = "$MODE_SHELL" ]; then
    echo "Starting shell"

    bash

else
    echo "You need to specify one of the parameters: $MODE_MASTER, $MODE_SHADOW, $MODE_METALOGGER, $MODE_CHUNKSERVER, $MODE_CGISERVER, or $MODE_SHELL"
fi
