#!/bin/bash
# Script:       jpack.sh
# ------------------------------------------------------------------------------------
# Description:  Packages the Java application by creating a {Project-Name}.jar file
#               from the compiled classes in the build folder. On macOS, the script
#               then creates a {Project-Name}.app bundle in $HOME/Applications/ with
#               the required folder structure, copies the JAR into the bundle, adds
#               the launcher script, converts and installs the application icon, and
#               generates the Info.plist file. Finally, it creates a symbolic link to
#               the .app bundle on the desktop.
#
#               (On Linux, this script previously created a launcher script and .desktop
#               file. On Windows, packaging behavior is still to be defined.)
# ------------------------------------------------------------------------------------
# Author:       Patrik Eigenmann
# email:        p.eigenmann72@gmail.com
# GitHub:       https://github.com/PatrikEigenmann72/PowerShell
# ------------------------------------------------------------------------------------
# Change Log:
# Thu 2025-08-14 File created and content added.                        Version: 00.01
# Wed 2025-09-17 Adding all classes from build folder.                  Version: 00.02
# Wed 2025-09-17 Resources folder added.                                Version: 00.03
# Sat 2026-04-04 Updated to create JAR and macOS .app bundle.           Version: 00.04
# Mon 2026-04-06 Added PkgInfo file and desktop link.                   Version: 00.05
# Mon 2026-04-06 Fixed a directory issue in the launcher script.        Version: 00.06
# Mon 2026-04-06 Fixed a directory issue in the jar command.            Version: 00.07
# Mon 2026-04-06 After copying the JAR, remove temporary jar folder.    Version: 00.08
# ------------------------------------------------------------------------------------

# Determine project name from current folder
PROJECT_NAME=$(basename "$PWD")
APP_NAME="${PROJECT_NAME}.app"
APP_DIR="$HOME/Applications/$APP_NAME"

echo "Packaging project: $PROJECT_NAME"

# ------------------------------------------------------------------------------------
# Step 1: Create the JAR file
# ------------------------------------------------------------------------------------

# Check if classpath.txt exists
if [ -f "classpath.txt" ]; then
    CLASSPATH=$(grep -v '^#' classpath.txt | tr '\n' ':')
    echo "Using classpath: $CLASSPATH"
else
    echo "classpath.txt not found. Proceeding without external libraries."
    CLASSPATH="."
fi

# Ensure build folder exists
if [ ! -d "build" ]; then
    echo "Error: build folder not found. Run jcompile.sh first."
fi

# Ensure manifest exists
if [ ! -f "manifest/MANIFEST.MF" ]; then
    echo "Error: manifest/MANIFEST.MF not found."
fi

# Create jar folder if missing
mkdir -p jar

# Create the JAR file (classes + manifest + resources)
echo "Creating JAR file..."

# FIXED: Ensure resources folder is packaged with correct structure
jar --create \
    --file "jar/${PROJECT_NAME}.jar" \
    --manifest manifest/MANIFEST.MF \
    -C build . \
    resources

echo "JAR created: jar/${PROJECT_NAME}.jar"

# ------------------------------------------------------------------------------------
# Step 2: Create macOS .app bundle
# ------------------------------------------------------------------------------------

echo "Creating macOS .app bundle..."

# Remove old bundle if it exists
if [ -d "$APP_DIR" ]; then
    rm -rf "$APP_DIR"
fi

# Create folder structure
mkdir -p "$APP_DIR/Contents/MacOS"
mkdir -p "$APP_DIR/Contents/Resources"

# ------------------------------------------------------------------------------------
# Step 3: Convert PNG icon to ICNS
# ------------------------------------------------------------------------------------

# Your original global icon path — restored
ICON_SRC="$HOME/icons/java-jar.png"
ICON_DST="$APP_DIR/Contents/Resources/${PROJECT_NAME}.icns"

if [ -f "$ICON_SRC" ]; then
    echo "Converting icon..."
    sips -s format icns "$ICON_SRC" --out "$ICON_DST" >/dev/null 2>&1
else
    echo "Warning: Icon not found at $ICON_SRC"
fi

# ------------------------------------------------------------------------------------
# Step 4: Copy JAR into bundle
# ------------------------------------------------------------------------------------

cp "jar/${PROJECT_NAME}.jar" "$APP_DIR/Contents/Resources/"

# Remove the temporary jar folder after copying
rm -rf jar

# ------------------------------------------------------------------------------------
# Step 5: Create launcher script
# ------------------------------------------------------------------------------------

LAUNCHER="$APP_DIR/Contents/MacOS/$PROJECT_NAME"

# FIXED: Set working directory so Finder behaves like Terminal
cat <<EOF > "$LAUNCHER"
#!/bin/bash
DIR="\$(cd "\$(dirname "\$0")/../Resources" && pwd)"
cd "\$DIR"
java -Xdock:name="$PROJECT_NAME" -Xdock:icon="\$DIR/${PROJECT_NAME}.icns" -cp "\$DIR/${PROJECT_NAME}.jar" App
EOF

chmod +x "$LAUNCHER"

# ------------------------------------------------------------------------------------
# Step 6: Create Info.plist
# ------------------------------------------------------------------------------------

cat <<EOF > "$APP_DIR/Contents/Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
 "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>${PROJECT_NAME}</string>
    <key>CFBundleExecutable</key>
    <string>${PROJECT_NAME}</string>
    <key>CFBundleIdentifier</key>
    <string>com.patrik.${PROJECT_NAME}</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundleIconFile</key>
    <string>${PROJECT_NAME}.icns</string>
</dict>
</plist>
EOF

# ------------------------------------------------------------------------------------
# Step 7: Create PkgInfo (missing in original)
# ------------------------------------------------------------------------------------

echo "APPL????" > "$APP_DIR/Contents/PkgInfo"

# ------------------------------------------------------------------------------------
# Step 8: Create Desktop symlink
# ------------------------------------------------------------------------------------

DESKTOP_LINK="$HOME/Desktop/$APP_NAME"

if [ -L "$DESKTOP_LINK" ] || [ -e "$DESKTOP_LINK" ]; then
    rm -f "$DESKTOP_LINK"
fi

ln -s "$APP_DIR" "$DESKTOP_LINK"

echo "Desktop link created."

# ------------------------------------------------------------------------------------
# Done
# ------------------------------------------------------------------------------------

echo "Packaging complete."
echo "App bundle: $APP_DIR"
echo "JAR file: jar/${PROJECT_NAME}.jar"