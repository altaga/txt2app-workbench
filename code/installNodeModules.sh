#!/bin/bash

# List of full paths to project folders
folders=("/project/code/app-render" "/project/code/frontend" "/project/code/Txt2App")

# Save the starting directory
starting_dir=$(pwd)

# Loop through each folder with specific checks and commands
for folder in "${folders[@]}"; do
    echo "Navigating to $folder..."
    
    # Check if the folder exists before proceeding
    if [ ! -d "$folder" ]; then
        echo "Folder $folder does not exist. Skipping..."
        continue
    fi

    # Navigate to the folder and check if cd was successful
    cd "$folder" || { echo "Failed to navigate to $folder. Skipping..."; continue; }
    echo "Now in $folder"

    # Check for node_modules and run npm install if missing
    if [ ! -d "node_modules" ]; then
        echo "node_modules missing in $folder, running npm install..."
        npm install
        echo "Finished npm install in $folder."
    else
        echo "node_modules exists in $folder."
    fi

    # For /project/code/app-render and /project/code/frontend, also check for the build folder
    if [[ "$folder" != "/project/code/Txt2App" ]]; then
        if [ ! -d "build" ]; then
            echo "build folder missing in $folder, running npm run build..."
            npm run build
            echo "Finished npm run build in $folder."
        else
            echo "build folder exists in $folder."
        fi
    fi

    # Return to the starting directory
    cd "$starting_dir" || exit
done

echo "All folders checked."