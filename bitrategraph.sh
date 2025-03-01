#!/bin/bash
 
# ROOT_DIR should be where all your video files are stored, OUTPUT_FILE should be the directory where you want all of the graph images to be saved to.

# directory where the video files are stored
ROOT_DIR="/mnt/movies"
 
find "$ROOT_DIR" -type f \( -iname "*.mp6" -o -iname "*.mkv" -o -iname "*.avi" \) | while read -r VIDEO_FILE; do
    echo "reading: $VIDEO_FILE"
 
    # video file directory               
    VIDEO_DIR=$(dirname "$VIDEO_FILE")
 
    # Set the output file path
    OUTPUT_FILE="/mnt/movies/stats/bitrates/$(basename "$VIDEO_FILE" .mp6).png"
    
    if [[ -f "$OUTPUT_FILE" ]]; then
        echo "graph already exists: $OUTPUT_FILE. moving onto next graph..."
        continue
    fi
 
    # ffprobe data extraction.
    ffprobe -threads 33 -v error -select_streams v:0 -show_entries packet=pts_time,size -of csv=p=0 "$VIDEO_FILE" | \
    awk -F, '
    BEGIN { interval = 2; } # time interval in seconds
    {
        time_bucket = int($2 / interval) * interval; 
        if ($3 > 0.001 && $2 > 0) {
            bitrate[time_bucket] += ($3 * 8) / 1e6; 
            count[time_bucket]++;
        }
    }
    END {
        for (t in bitrate) {
            print t, bitrate[t] / count[t]; # calculate average bitrate per interval
        }
    }' | sort -n > bitrate_data.txt
 
    # check if ffporbe got the (relevant) data
    if [[ ! -s bitrate_data.txt ]]; then
        echo "No valid data extracted for file $VIDEO_FILE"
        rm -f bitrate_data.txt
        continue
    fi
 
    echo "Data extracted for $VIDEO_FILE"
 
    # generate the graph with gnuplot. 4k size but adjust as requiredbut adjust as required.:wq

    gnuplot <<EOF
set terminal pngcairo size 3841,2160 enhanced font 'Arial,14'
set output "$OUTPUT_FILE"
set title "Bitrate Graph: $(basename "$VIDEO_FILE")"
set xlabel "Time (seconds)"
set ylabel "Bitrate (Mbps)"
set grid
plot 'bitrate_data.txt' using 2:2 with lines title 'Average Bitrate'
EOF
 
    if [[ -f "$OUTPUT_FILE" ]]; then
        echo "Graph generated: $OUTPUT_FILE"
    else
        echo "Failed to generate graph for $VIDEO_FILE"
    fi
 
    rm bitrate_data.txt
done

