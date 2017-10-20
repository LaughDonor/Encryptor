#!/bin/bash
SCRIPT=`basename ${BASH_SOURCE[0]}`
rootcert=certs/rootcert.pem
output=sigtag.xml
verify=false
encrypt=false

## Let's do some admin work to find out the variables to be used here
BOLD='\e[1;31m'         # Bold Red
REV='\e[1;32m'          # Bold Green
OFF='\e[0m'

#Usage function
function HELP {
  echo -e "${REV}Basic usage:${OFF} ${BOLD}$SCRIPT [-o <Output File>] [-s <PKCS#12 Certificate>] [-v] XMLfile ${OFF}"\\n
  echo -e "${REV}The following switches are recognized. $OFF "
  echo -e "${REV}-o <Output File>${OFF}          --Specifies the output file. If not supplied, will output stdout."
  echo -e "${REV}-s <PKCS#12 Certificate>${OFF}  --Adds Signature to input XML file using given ${BOLD}.p12${OFF} cert. The cert password will be requested."
  #echo -e "${REV}-e <Params?>${OFF}             --Encrypts the input XML file${OFF}"
  echo -e "${REV}-v ${OFF}                       --Verifies a signed XML file. If combined with ${REV}-s${OFF} option, verifies newly signed XML."
  echo -e "${REV}-h ${OFF}                       --Displays this help message. No further functions are performed."\\n
  echo -e "Example: ${BOLD}$SCRIPT -s certs/usercert.p12 -v sample.xml${OFF}"\\n
  exit 1
}

# In case you wanted to check what variables were passed
# echo "flags = $*"

while getopts :hvs:o: FLAG; do
	case $FLAG in
		o)
			output=$OPTARG
			;;
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
			echo -e "Option ${BOLD}-$OPTARG ${OFF}requires an argument." >&2
			exit 1
			;;
		\?) #unrecognized option - show help
			echo -e \\n"Option ${BOLD}-$OPTARG ${OFF}not allowed."\\n
			HELP
			;;
	esac
done
shift $((OPTIND -1))
xml=$1

if [[ -z "$xml" ]]; then 
    echo -e \\n"Missing ${BOLD}XMLFile${OFF} argument."\\n
	HELP
fi

if [[ -f $cert ]]; then
	if ! grep -Fq "<Signature" "$xml"; then
		xsltproc -o "$output" templates/signed.xsl "$xml"
	else
		cp "$xml" "$output"
	fi
	xml=$output
	read -s -p "Certificate Password: " certpass
	echo
	errors=$(xmlsec1 --sign --pkcs12 $cert --trusted-pem $rootcert --crypto openssl --pwd "$certpass" --output "$xml" "$xml" 2>&1)
	if [ $output != "sigtag.xml" ]; then
		cat "$xml"
	fi
elif [[ -n $cert ]]; then
    echo -e "Certificate file ${BOLD}$cert ${OFF}not found." >&2
	exit 1
fi

if [ -n "$errors" ]; then
	echo "$errors"
else
	if $verify; then
		xmlsec1 --verify --trusted-pem "$rootcert" "$xml"
	fi

	if [ $output = "sigtag.xml" ]; then
		rm "$output"
	fi
fi