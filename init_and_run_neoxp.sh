#!/bin/bash

optstring=":hs:"
function usage {
  echo "Usage: $(basename $0) [-sh]" 2>&1
  echo '   -h   Shows help information'
  echo '   -s   Sets time between blocks'
}

if [[ ! ${#} -eq 0 ]]; then
  while getopts ${optstring} option; do
    case ${option} in

      s)
        BLOCKTIME="${OPTARG}"
        ;;
      h)
        usage
        exit 0
        ;;
      :)
        echo "$0: Must supply an argument to -$OPTARG." >&2
        exit 1
        ;;
      ?)
        echo "Invalid option: -${OPTARG}."
        exit 2
        ;;
    esac
  done
fi

if [ ! -f "default.neo-express" ]; then
  neoxp create -f
fi

if [ -f "setup.neoxp-checkpoint" ]; then 
  neoxp checkpoint restore -f setup.neoxp-checkpoint
  echo 'Checkpoint restored.'
fi

if [ -f "setup.batch" ]; then 
  neoxp batch -r setup.batch
  echo 'Batch applied.'
fi

if [ -z "$BLOCKTIME" ]; then
  neoxp run
else
  neoxp run -s $BLOCKTIME
fi

