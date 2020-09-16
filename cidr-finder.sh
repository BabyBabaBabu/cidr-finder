#!/usr/bin/env bash

# Global Variables
BASE_URL="https://api.bgpview.io/"
QUERY=""
PARAM=""
SANITIZER=""
# Full path to current script
THIS=`readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0`
# The directory where script resides
# The directory where to store results
mkdir -p $DIR/results/
RES=$DIR/results/

usage(){
      echo -e "$0 - Query CIDR Info of a target\n"
      echo -e "Usage:\t./$0 [options] [parameters]\n"
      echo -e "Options:"
      echo -e "\t-o <org name>\tQuery by Organization name."
      echo -e "\t-d <domain>\tQuery by Domain"
      echo -e "\t-i <ip address>\tQuery by IP Address"
      echo -e "\t-a <AS Number>\tQuery by ASN"
      echo -e "\t-h\t\tDisplay this help message."
      echo -e ""
      echo -e "Examples:"
      echo -e "\t./$0 -o hackerone"
      echo -e "\t./$0 -d hackerone.com"
      echo -e "\t./$0 -i 104.16.99.52"
      echo -e "\t./$0 -a AS15169"
      echo -e ""
}

#if no argument passed; print usage
if [[ $# -eq 0 ]] ; then
	usage
	exit 1
fi

while (( $# )); do
    
    case $1 in
        -h | --help)
            usage
            exit
            ;;
         -i | --ip)
            QUERY="ip/"
            PARAM=$2
            SANITIZER=".data.rir_allocation.prefix,.data.prefixes[].prefix"
            echo -e $(curl -s $BASE_URL$QUERY$PARAM) | jq --raw-output $SANITIZER | tee -a $RES$PARAM.txt
            exit 0
            ;;
         -a | --asn)
            QUERY="asn/"
            PARAM=$(echo $2 | sed 's/[A-Za-z]*//g')
            SANITIZER=".data.ipv4_prefixes[].prefix,.data.ipv6_prefixes[].prefix"
            echo -e $(curl -s $BASE_URL$QUERY$PARAM) | jq --raw-output $SANITIZER | tee -a $RES$PARAM.txt
            exit 0
            ;;
         -d | --domain)
            QUERY="ip/"
            SANITIZER=".data.rir_allocation.prefix,.data.prefixes[].prefix"
            echo -e $(for PARAM in $(dig +short $2); do \
            echo -e $(curl -s $BASE_URL$QUERY$PARAM) \
            | jq --raw-output $SANITIZER | sort -u |tee -a $RES$2.txt; done) 
            exit 0
            ;;
         -o | --org)
            QUERY="search?query_term="
            PARAM=$2
            SANITIZER=".data.ipv6_prefixes[].parent_prefix,.data.ipv4_prefixes[].parent_prefix"
            echo -e $(curl -s $BASE_URL$QUERY$PARAM) | jq --raw-output $SANITIZER | tee -a $RES$PARAM.txt
            exit 0
            ;;
 	*)
            echo -e "ERROR: unknown parameter \"$1\" \n"
            usage
            exit 1
            ;;
    esac
done
