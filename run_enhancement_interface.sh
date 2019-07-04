#!/bin/bash
# This script demonstrates how to run speech enhancement.


###################################
# Run speech enhancement
###################################
# Directory of WAV files (16 kHz, 16 bit) to enhance.
wav_path=$1

# Output directory for enhanced WAV.
output_path=$2


export PATH=/home/leisun1/local/mpi/bin:$PATH
export LD_LIBRARY_PATH=/home/leisun1/local/mpi/lib:$LD_LIBRARY_PATH


USE_GPU=true  # Use GPU instead of CPU. To instead use CPU, set to 'false'.
GPU_DEVICE_ID=`free-gpu`  # Use GPU with device id 0. Irrelevant if using CPU.
TRUNCATE_MINUTES=10  # Duration in minutes of chunks for enhancement. If you experience
                     # OOM errors with your GPU, try reducing this.
MODEL_SELECT=1000h  # Use which pre-trained model, currently including: a 400-h model and a 1000h-model.
MODE=3   #Use which output of the model: mode=1 is irm, mode=2 is lps, mode=3 is fusion of both.
STAGE_SELECT=3 # Only works if choosing  1000h-model.

/home/leisun1/anaconda3/envs/cntk-py35/bin/python  /export/fs01/jsalt19/leisun/speech_enhancement/denoising_DIHARD18/main_denoising.py  \
       --verbose \
       --wav_dir $wav_path --output_dir $output_path \
       --use_gpu $USE_GPU --gpu_id $GPU_DEVICE_ID \
       --truncate_minutes $TRUNCATE_MINUTES \
       --mode $MODE \
       --model_select $MODEL_SELECT \
       --stage_select $STAGE_SELECT
