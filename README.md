# Mouse Brain CFOS Analysis

This script is designed to analyze mouse brain sections for CFOS based on Stardist DAPI nuclei segmentation.

**DOI**: 

## Author

Daniel Waiger
- **Email**: daniel.waiger@mail.huji.ac.il
- **Image.sc forum**: Daniel_Waiger

- **Institution**: CSI – Center for Scientific Imaging at The Robert H. Smith Faculty of Agriculture, Food and Environment of the Hebrew University of Jerusalem
- **Website**: [Faculty of Agriculture CSI Microscopy](https://github.com/Faculty-of-Agriculture-CSI-Microscopy)


## Description

### Dialogs and GUIs
<p align="left">
    <img src="https://github.com/user-attachments/assets/0591d04a-8d5f-449a-9523-9e149ee32090" width="33%" alt="Analysis Parameters">
    <img src="https://github.com/user-attachments/assets/77a50562-98d3-4878-ae43-6f7c5eb16881" width="33%" alt="ROI Selection Dialog">
</p>

<p align="left">
    <img src="https://github.com/user-attachments/assets/64cdb5e3-9471-4d05-b373-e375a1afb8bc" width="37%" alt="Wait For User Dialog">
    <img src="https://github.com/user-attachments/assets/49b6e927-70d4-44a5-bf1e-cbc1611c621b" width="33%" alt="ROI Validation Dialog"> 
   
</p>


<p align="left">
    <img src="https://github.com/user-attachments/assets/5b2c7227-33f3-4598-9b49-c0184dc07e4e" width="35%" alt="Image and ROI Overlay">
    <img src="https://github.com/user-attachments/assets/6c59c0cd-ab32-44c3-8451-ddd5af2f7ba3" width="35%" alt="Image and ROI Overlay">
</p>

<p align="left">
    <img src="https://github.com/user-attachments/assets/e14cb19e-e308-41ad-864e-db472dc6ce2c" width="28%" alt="Analysis Progress Log">
</p>



### Script steps

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
2. Install the Bio-Formats plugin.
   - To load `.ims` files and select the `Resolution Level` (Defined as `Series` in the script).
3. Install the StarDist plugin.
### Both plugins can be installed via the `Help` Menu --> `Update...` --> `Manage Update Sites`

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
    D -->|Invalid| E[Exit: No image file, .ims, or output directory selected]
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
    N --> O[Segment Channel 1]
    O --> P[Measure Channel 2]
    P --> Q[Run StarDist segmentation on Channel 1]
    Q --> R[Save results and ROI sets]
    R --> S[Clear Results table]
    S --> T[Print total run time]
    T --> U[End Script]
```
