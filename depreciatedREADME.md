Simple script to generate bitrate graphs for videos.

# USAGE
Requires the following:
    • **ffprobe**
    • **ffmpeg** (may not be required)
    • **gnuplot**

The script takes a video directory full of files and outputs **graphs** of the video's **bitrates**. To config, edit the bitrateGraph.sh file and replace the two variables:
    ROOT_DIR: The directory where all the videos are stored
    OUTPUT_FILE: The directory where you want the graphs to be generated

The graphs generated will  be in resoloution 3841x2160 (4K), but thi can be adjused by changing these numbers
    set terminal pngcairo size **3841,2160** enhanced font 'Arial,14'

