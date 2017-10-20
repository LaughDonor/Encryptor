#!/bin/bash
SCRIPT=`basename ${BASH_SOURCE[0]}`

## Let's do some admin work to find out the variables to be used here
BOLD='\e[1;31m'         # Bold Red
REV='\e[1;32m'          # Bold Green
OFF='\e[0m'

#Usage function
function HELP {
  echo -e "${REV}Basic usage:${OFF} ${BOLD}$SCRIPT [-s <PKCS#12 Certificate>] [-v] XMLfile ${OFF}"\\n
  echo -e "${REV}The following switches are recognized. $OFF "
  echo -e "${REV}-s <PKCS#12 Certificate>${OFF}  --Adds Signature to input XML file using given ${BOLD}.p12${OFF} cert. The cert password will be requested."
  #echo -e "${REV}-e <Params?>${OFF}             --Encrypts the input XML file${OFF}"
  echo -e "${REV}-v ${OFF}                       --Verifies a signed XML file. If combined with ${REV}-s${OFF} option, verifies newly signed XML."
  echo -e "${REV}-h ${OFF}                       --Displays this help message. No further functions are performed."\\n
  echo -e "Example: ${BOLD}$SCRIPT -s certs/usercert.p12 -v sample.xml${OFF}"\\n
  exit 1
}

# In case you wanted to check what variables were passed
# echo "flags = $*"

while getopts :hvs: FLAG; do
  case $FLAG in
    s)
      cert=$OPTARG
      ;;
    v)
      verify=true
      ;;
    e)
      encrypt=true
      ;;
    h)
      HELP
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
    \?) #unrecognized option - show help
      echo -e \\n"Option ${BOLD}-$OPTARG ${OFF}not allowed."\\n
      HELP
      ;;
  esac
done
shift $((OPTIND -1))

if [[ -z $1 ]] 
then 
    echo -e \\n"Missing ${BOLD}XMLFile${OFF} argument."\\n
	HELP
fi

echo "Run Tool"