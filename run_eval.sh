#!/bin/bash
# This script demonstrates how to run speech enhancement and VAD. For full documentation,
# please consult the docstrings of ``main_denoising.py`` and ``main_get_vad.py``.


###################################
# Run speech enhancement
###################################
export PATH=/home/leisun1/local/mpi/bin:$PATH
export LD_LIBRARY_PATH=/home/leisun1/local/mpi/lib:$LD_LIBRARY_PATH


WAV_DIR=/export/fs01/jsalt19/leisun/dataset/SRI/testset/origin_uncomplete/  # Directory of WAV files (16 kHz, 16 bit) to enhance.
SE_WAV_DIR=/export/fs01/jsalt19/leisun/dataset/SRI/testset/SE_1000h_model_m3_s3/
# Output directory for enhanced WAV.
USE_GPU=true  # Use GPU instead of CPU. To instead use CPU, set to 'false'.
GPU_DEVICE_ID=`free-gpu`  # Use GPU with device id 0. Irrelevant if using CPU.
TRUNCATE_MINUTES=10  # Duration in minutes of chunks for enhancement. If you experience
                     # OOM errors with your GPU, try reducing this.
MODE=3   #Use which output of the model: mode=1 is irm, mode=2 is lps, mode=3 is fusion of both.
MODEL_SELECT=1000h  # Use which pre-trained model, currently including: a 400-h model and a 1000h-model.
STAGE_SELECT=3 # Only works if choosing  1000h-model.

/home/leisun1/anaconda3/envs/cntk-py35/bin/python /export/fs01/jsalt19/leisun/speech_enhancement/denoising_DIHARD18/main_denoising.py  \
       --verbose \
       --wav_dir $WAV_DIR --output_dir $SE_WAV_DIR \
       --use_gpu $USE_GPU --gpu_id $GPU_DEVICE_ID \
       --truncate_minutes $TRUNCATE_MINUTES \
       --mode $MODE \
	   --model_select $MODEL_SELECT \
	   --stage_select $STAGE_SELECT 




exit 0


###################################
# Perform VAD using enhanced audio
###################################
VAD_DIR=/data/vad  # Output directory for label files containing VAD output.
HOPLENGTH=30  # Duration in milliseconds of frames for VAD. Also controls step size.
MODE=3  # WebRTC aggressiveness. 0=least agressive and  3=most aggresive.
NJOBS=1  # Number of parallel processes to use.
python main_get_vad.py \
       --verbose \
       --wav_dir $SE_WAV_DIR --output_dir $VAD_DIR \
       --mode $MODE --hoplength $HOPLENGTH \
       --n_jobs $NJOBS || exit 1

exit 0
