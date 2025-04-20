#!/bin/bash

echo "Do you want to export or import VSCode extensions? (export/import)"
read action

if [ "$action" == "export" ]; then
    echo "Exporting VSCode extensions..."

    # Create markdown file with header
    DATE=$(date +"%Y-%m-%d")
    FILENAME="vscode-extensions-$DATE.md"
    echo "# VS Code Extensions" >$FILENAME
    echo "" >>$FILENAME
    echo "Exported on: $DATE" >>$FILENAME
    echo "" >>$FILENAME
    echo "## Installed Extensions" >>$FILENAME
    echo "" >>$FILENAME

    # Get extensions and add them to markdown content
    code --list-extensions | while read ext; do
        echo "- $ext" >>$FILENAME
    done

    echo "Extensions have been exported to $FILENAME"
elif [ "$action" == "import" ]; then
    echo "Importing VSCode extensions..."

    # Find the most recent extensions file
    LATEST_FILE=$(ls -t vscode-extensions*.md | head -n 1)
    
    if [ -z "$LATEST_FILE" ]; then
        echo "Error: No extensions file found."
        exit 1
    fi
    
    echo "Using file: $LATEST_FILE"
    
    if [ -f "$LATEST_FILE" ]; then
        # Extract extension IDs from markdown file (lines starting with "- ")
        grep '^- ' "$LATEST_FILE" | sed 's/^- //' | while read extension; do
            echo "Installing extension: $extension"
            code --install-extension "$extension"
        done
        echo "Extensions have been imported from $LATEST_FILE"
    else
        echo "Error: vscode-extensions.md file not found."
    fi
else
    echo "Invalid action. Please choose 'export' or 'import'."
fi
