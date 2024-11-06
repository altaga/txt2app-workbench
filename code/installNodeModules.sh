#!/bin/bash

# List of full paths to project folders
folders=("/project/code/app-render" "/project/code/frontend" "/project/code/Txt2App")

# Save the starting directory
starting_dir=$(pwd)

# Function to perform checks in each folder
check_folder() {
    folder=$1
    
    echo "Checking $folder..."

    # Check if the folder exists
    if [ ! -d "$folder" ]; then
        echo "Folder $folder does not exist. Skipping..."
        return
    fi

    # Navigate to the folder
    cd "$folder" || { echo "Failed to navigate to $folder. Skipping..."; return; }

    # Check for node_modules and run npm install if missing
    if [ ! -d "node_modules" ]; then
        echo "node_modules missing in $folder, running npm install..."
        npm install
        echo "Finished npm install in $folder."
    else
        echo "node_modules exists in $folder."
    fi

    # For specific folders, check for the build folder
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
}

# Run checks in parallel
for folder in "${folders[@]}"; do
    check_folder "$folder" &
done

# Wait for all background processes to finish
wait

echo "All folders checked."
