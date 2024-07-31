# Mouse Brain CFOS Analysis

This script is designed for analyzing mouse brain sections for CFOS, based on Stardist DAPI nuclei segmentation.
It was created by Daniel Waiger from the Bio-imaging & Flow Cytometry Core Facility at The Robert H. Smith Faculty of Agriculture, Food and Environment of the Hebrew University of Jerusalem.

## Author

Daniel Waiger
- **Email**: daniel.waiger@mail.huji.ac.il
- **Image.sc forum**: Daniel_Waiger

- **Institution**: CSI – Center for Scientific Imaging at The Robert H. Smith Faculty of Agriculture, Food and Environment of the Hebrew University of Jerusalem
- **DOI**: 

## Description

The script performs the following steps:
1. Opens the selected image file.
2. Performs a sum projection of the image.
3. Splits the image into channels.
4. Applies LUTs (Look-Up Tables) to the channels.
5. Prompts the user to select an ROI (Region of Interest) or processes the entire image.
6. Processes the selected channels.
7. Runs StarDist segmentation on the DAPI channel.
8. Saves the results and ROI sets.
9. Prints the total run time.

## Requirements

- ImageJ/Fiji
- Bio-Formats Plugin
- StarDist Plugin

## Installation

1. Install ImageJ/Fiji from the [official website](https://imagej.net/software/fiji/downloads).
2. Install the Bio-Formats plugin from the [official website](https://www.openmicroscopy.org/bio-formats/downloads/).
3. Install the StarDist plugin from the [official GitHub repository](https://github.com/stardist/stardist).

## Usage

1. Open ImageJ/Fiji.
2. Load the macro script into ImageJ/Fiji.
3. Run the script.
4. Follow the prompts to select the image file, save directory, channel names, and ROI selection.

# Mouse Brain CFOS Analysis Script Flowchart
```mermaid
graph TD
    A[Start Script] --> B[Close all open images]
    B --> C[Collect user-defined parameters]
    C --> D{Validate inputs}
    D -->|Invalid| E[Exit: No image file or save directory selected]
    D -->|Valid| F[Open image and set measurements]
    F --> G[Perform sum projection]
    G --> H[Split channels]
    H --> I[Apply LUTs to split images]
    I --> J{Select ROI?}
    J -->|Yes| K[Prompt user to select ROI]
    K --> L[Confirm ROI selection]
    L -->|Confirmed| M[Process selected ROI]
    J -->|No| N[Process entire image with the
    risk of crashing Fiji
    when loading big images]
    M --> O[Process Channel 1]
    N --> O[Process Channel 1]
    O --> P[Process Channel 2]
    P --> Q[Run StarDist segmentation on Channel 1]
    Q --> R[Save results and ROI sets]
    R --> S[Clear Results table]
    S --> T[Print total run time]
    T --> U[End Script]
```
