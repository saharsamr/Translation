#!/bin/bash

FPATH=/content/drive/MyDrive/data

for checkpoint in $FPATH/checkpoints/fconv/*.pt; do
    echo "# Translating with checkpoint $checkpoint"
    
    fairseq-generate $FPATH/run/data.tokenized.fa-en \
    --path $checkpoint \
    --batch-size 128 --beam 5 > $checkpoint.tmp
    tail $checkpoint.tmp -n 1
done