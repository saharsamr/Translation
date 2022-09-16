#!/bin/bash

DATA_PATH=/content/drive/MyDrive/data
if true; then
 echo "$0: Training sentencepiece model"
   rm -f $DATA_PATH/train.txt
fi

for f in $DATA_PATH/train.en $DATA_PATH/train.fa
 do
  cat $f >> $DATA_PATH/train.txt
 done

 spm_train --input=$DATA_PATH/train.txt --model_prefix=$DATA_PATH/wmtenfa \
          --character_coverage=1

 