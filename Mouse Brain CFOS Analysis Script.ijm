// Script Name: Mouse Brain CFOS Analysis Script
// This code was made by Daniel Waiger from the Bio-imaging & Flow Cytometry Core Facility
// CSI – Center for Scientific Imaging at The Robert H. Smith – Faculty of Agriculture, Food and Environment of the Hebrew University of Jerusalem
// daniel.waiger@mail.huji.ac.il
// image.sc forum: Daniel_Waiger

// For: [Full Name] of [Lab] in [institute].
// doi:

// Start timer
startTime = getTime();

// Close all open images to start fresh
close("*");
run("Clear Results");
print("\\Clear");
roiManager("Reset");

// Collect user-defined parameters
Dialog.create("Image Analysis Parameters");
Dialog.addFile("Select the image file to open:", "");
Dialog.addDirectory("Choose a directory to save results:", "");
Dialog.addString("Enter name for Channel 1 (e.g., DAPI):", "Ch-1");
Dialog.addString("Enter name for Channel 2 (e.g., CFOS):", "Ch-2");
Dialog.show();

// Get the user inputs
openPath = Dialog.getString();
savePath = Dialog.getString();
channel1Name = Dialog.getString();
channel2Name = Dialog.getString();

// Error handling for file paths
if (openPath == "") {
    exit("No image file selected. Exiting script.");
}
if (savePath == "") {
    exit("No save directory selected. Exiting script.");
}

// Print parameters to the log window
print("Image Analysis Parameters:");
print("Selected image file: " + openPath);
print("Save directory: " + savePath);
print("Channel 1 name: " + channel1Name);
print("Channel 2 name: " + channel2Name);

// Open the image and set measurements
print("Opening image...");
originalFileName = File.getNameWithoutExtension(openPath);
run("Bio-Formats Importer", "open=[" + openPath + "] autoscale color_mode=Composite rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_1");
setOption("ScaleConversions", true);
run("Set Measurements...", "area mean modal min integrated display redirect=None decimal=3");
print("Image opened and measurements set.");

// Perform sum projection
print("Performing sum projection...");
run("Duplicate...", "title=copy duplicate");
run("Z Project...", "projection=[Sum Slices]");
print("Sum projection completed.");

// Split Channels
print("Splitting channels...");
run("Split Channels");
print("Channels split.");

// Apply LUTs to split images
print("Applying LUTs to split images...");
selectWindow("C1-SUM_copy");
rename(channel1Name);
run("8-bit");
run("Cyan");
print(channel1Name + " channel processed with Cyan LUT.");

selectWindow("C2-SUM_copy");
rename(channel2Name);
run("8-bit");
run("Magenta");
print(channel2Name + " channel processed with Magenta LUT.");

run("Tile");
print("LUTs applied to split images.");

// Prompt user for ROI selection
roiSet = getBoolean("Select an ROI?\nNO means that the entire image will be processed.");
if (roiSet) {
    done = false;
    while (!done) {
        // Activate polygon tool and wait for user to make a selection
        setTool("polygon");
        waitForUser("Please select an ROI and click OK.");
        
        // Ask user to confirm the selection
        confirm = getBoolean("Are you satisfied with the selected ROI?");
        if (confirm) {
            done = true;
        }
    }
    // Add ROI to the manager and show all
    roiManager("Add");
    if (roiSet) {
    roiManager("Add");
    roiManager("Select", roiManager("count") - 1);
    roiManager("Save", savePath + "selected_roi.zip");
    print("ROI selected by user, and saved to" + savePath);
} else {
    print("Processing entire image.");
}

// Process Channel 1
print("Processing Channel 1...");
selectWindow(channel1Name);
run("Duplicate...", "title=" + originalFileName + "_SUM_ROI_" + channel1Name + ".tif");
run("Clear Outside");
print("Channel 1 processed.");

// Process Channel 2
print("Processing Channel 2...");
selectWindow(channel2Name);

// Restore the ROI from the manager
roiManager("Select", roiManager("count") - 1); // Select last added ROI
run("Duplicate...", "title=" + originalFileName + "_SUM_ROI_" + channel2Name + ".tif");
run("Clear Outside");
run("Enhance Contrast", "saturated=0.35");
run("Tile");
print("Channel 2 processed.");

// Reset ROI Manager to prevent interference
roiManager("Show None");
roiManager("Reset");


// StarDist segmentation on Channel 1
print("Running StarDist segmentation on Channel 1...");
run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input':'" + originalFileName + "_SUM_ROI_" + channel1Name + ".tif', 'modelChoice':'Versatile (fluorescent nuclei)', 'normalizeInput':'true', 'percentileBottom':'1.0', 'percentileTop':'99.8', 'probThresh':'0.479071', 'nmsThresh':'0.3', 'outputType':'Both', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'true', 'showCsbdeepProgress':'true', 'showProbAndDist':'false'], process=[false]");
run("Tile");
print("StarDist segmentation completed.");

// Save results with relevant details
selectWindow(originalFileName + "_SUM_ROI_" + channel1Name + ".tif");
saveAs("Tiff", savePath + originalFileName + "_SUM_ROI_" + channel1Name + ".tif");
selectWindow(originalFileName + "_SUM_ROI_" + channel2Name + ".tif");
roiManager("Show All");
roiManager("Deselect");
roiManager("Measure");
saveAs("Tiff", savePath + originalFileName + "_SUM_ROI_" + channel2Name + ".tif");
roiManager("Save", savePath + originalFileName + "_RoiSet.zip");
print("Saving results...");

saveAs("Results", savePath + originalFileName + "_Results.csv");
print("Results saved.");
print("Images and ROI sets saved.");

// Print total run time
endTime = getTime();
totalTime = (endTime - startTime) / 1000;
print("Total run time: " + totalTime + " seconds.");
