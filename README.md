Simple script to generate bitrate graphs for videos.

# USAGE
Requires the following:
    • **ffprobe**
    • **ffmpeg** (may not be required)
    • **gnuplot**

The script takes a video directory full of files and outputs **graphs** of the video's **bitrates**. It will ask for the directory where your video files are stored and output them in a given direcory

The graphs generated will  be in resoloution 3841x2160 (4K), but thi can be adjused by changing these numbers
    set terminal pngcairo size **3841,2160** enhanced font 'Arial,14'

