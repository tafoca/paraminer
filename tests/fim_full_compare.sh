#!/bin/bash
##
## full_compare.sh
## 
## Made by Benjamin Negrevergne
## Login   <bengreve@neb.imag.fr>
## 
## Started on  Mon Nov 22 15:14:00 2010 Benjamin Negrevergne
## Last update Mon Nov 22 15:14:00 2010 Benjamin Negrevergne
##

usage(){
echo "Usage: ./fim_full_compare dataset minsup" 1>&2
echo "Compare results produced by ParaMiner (fim) with results produced by lcm25." 1>&2
echo "Succeed if results are identical" 1>&2
exit 1
}

PARAMINER_FIM="paraminer_itemsets"
LCM_FIM="lcm25"

if [ $# -lt 2 -o $# -gt 3 ]; then usage; fi
if [ -f $1 ]; then DATASET=$1; else echo "Dataset file: '$1' not found." 1>&2; usage; fi
if [[ $2 =~ ^[0-9]+([.][0-9]+)?$ ]]; then THRES=$2;\
 else echo "Theshold: '$2' is not a numeric value." 1>&2; usage; fi
if [ $# -eq 2 ]; then \
    NUM_THREAD="1"; else \
    if [[ $3 =~ ^[0-9]+$ ]]; then NUM_THREADS=$3;\
 else echo "Number of threads: '$3' is not a integer value." 1>&2; usage; fi; fi

CMD_LINE="$LCM_FIM $DATASET $THRES /tmp/lcmout"

echo "CMD LINE: >$CMD_LINE<"

$CMD_LINE > /dev/null
sort_line.pl x < /tmp/lcmout  > /tmp/lcmout2 && sort < /tmp/lcmout2 > /tmp/lcmout

if [ ! -f /tmp/lcmout ]; then \
    echo "Error: Could not produce LCM output file." 1>&2; fi

CMD_LINE="$PARAMINER_FIM  $DATASET $THRES -t $NUM_THREADS"
echo "CMD LINE: >$CMD_LINE<"
$CMD_LINE | sort_line.pl x | sort > /tmp/pmout

if [ ! -f /tmp/pmout ]; then \
    echo "Error: Could not produce ParaMiner output file." 1>&2; fi

diff /tmp/lcmout /tmp/pmout 