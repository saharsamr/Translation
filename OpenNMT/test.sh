#!/bin/bash

FPATH=/content/drive/MyDrive/data/run

spm_encode --model=/content/drive/MyDrive/data/wmtenfa.model \
    < /content/drive/MyDrive/data/test.en \
    > /content/drive/MyDrive/data/test.en.sp
spm_encode --model=/content/drive/MyDrive/data/wmtenfa.model \
    < /content/drive/MyDrive/data/test.fa \
    > /content/drive/MyDrive/data/test.fa.sp

for checkpoint in $FPATH/model_step*.pt; do
    echo "# Translating with checkpoint $checkpoint"
    base=$(basename $checkpoint)
    onmt_translate \
        -gpu 0 \
        -batch_size 16384 -batch_type tokens \
        -beam_size 5 \
        -model $checkpoint \
        -src /content/drive/MyDrive/data/test.en.sp \
        -tgt /content/drive/MyDrive/data/test.fa.sp \
        -output /content/drive/MyDrive/data/test.fa.hyp_${base%.*}.sp
done

for checkpoint in $FPATH/model_step*.pt; do
    base=$(basename $checkpoint)
    spm_decode \
        -model=/content/drive/MyDrive/data/wmtenfa.model \
        -input_format=piece \
        < /content/drive/MyDrive/data/test.fa.hyp_${base%.*}.sp \
        > /content/drive/MyDrive/data/test.fa.hyp_${base%.*}
done

for checkpoint in /content/drive/MyDrive/data/run/model_step*.pt; do
    echo "$checkpoint"
    base=$(basename $checkpoint)
    sacrebleu /content/drive/MyDrive/data/test.fa < /content/drive/MyDrive/data/test.fa.hyp_${base%.*}
done
