#!/bin/bash

# === Validate input ===
if [ -z "$1" ]; then
  echo "❌ No project name provided."
  echo "Usage: jproject.sh <ProjectName>"
  exit 1
fi

PROJECT="$1"
DATE="$(date +"%a %Y-%m-%d")"
echo "📦 Initializing Java project: $PROJECT"

# Ensure .gitignore ends with a newline before appending
if [ -f ".gitignore" ]; then
  tail -c1 .gitignore | read -r _ || echo >> .gitignore
fi

if ! grep -qx "$PROJECT/" .gitignore; then
  echo "/$PROJECT/" >> .gitignore
  echo "📄 Added '/$PROJECT/' to local .gitignore"
fi

# === Create folder structure ===
mkdir -p "$PROJECT"/{bin,build,lib,manifest,scripts,src/"$PROJECT"/Gui,src/"$PROJECT"/Utility}

# === Create App.java in default package ===
cat << EOF > "$PROJECT/src/App.java"
/* -------------------------------------------------------------------------------
 * App.java -  The App class serves as the entry point for the application. When
 * the user launches the program—whether by double-clicking an icon or running it
 * from the command line—the system needs a defined starting point. This class
 * provides that by containing the main method.
 * 
 * The main method is where execution begins, initializing necessary components and
 * setting the application into motion. It ensures that the first frame, user
 * interface, and core functionality are properly instantiated.
 *
 * In a structured software environment, every project needs a single place where
 * the system knows to start. This class fulfills that role, keeping the application
 * streamlined and predictable across multiple use cases.
 * -------------------------------------------------------------------------------
 * Author:      Patrik Eigenmann
 * eMail:       p.eigenmann@gmx.net
 * GitHub:      https://www.github.com/PatrikEigenmann/$PROJECT
 * -------------------------------------------------------------------------------
 * Change Log:
 * $DATE File created.                                     Version: 00.01
 * ------------------------------------------------------------------------------- */

/* Javax Swing SwingUtilities import */ 
import javax.swing.SwingUtilities;

/* $PROJECT Gui MainFrame import */
import $PROJECT.Gui.MainFrame;
import $PROJECT.Utility.Debug;

/**
 * App.java -  The App class serves as the entry point for the application. When
 * the user launches the program—whether by double-clicking an icon or running it
 * from the command line—the system needs a defined starting point. This class
 * provides that by containing the main method.
 * 
 * The main method is where execution begins, initializing necessary components and
 * setting the application into motion. It ensures that the first frame, user
 * interface, and core functionality are properly instantiated.
 *
 * In a structured software environment, every project needs a single place where
 * the system knows to start. This class fulfills that role, keeping the application
 * streamlined and predictable across multiple use cases.
 */ 
public class App {

    /**
     * The main method acts as the starting point of the application. When the program
     * is launched, execution begins here, ensuring that all necessary components are
     * initialized and the user interface is displayed.
     *
     * This method is responsible for setting the application in motion. It ensures
     * that the primary frame is created and rendered within the correct thread
     * context to maintain responsiveness and stability.
     *
     * In structured software design, having a clearly defined entry point allows for
     * predictable execution, making the application easy to manage and extend.
     *
     * @param args Command-line arguments passed during application startup.
     *             These can be used for configuration or debugging but are
     *             typically not required in standard executions.
     */
    public static void main(String[] args) {
        Debug.init(Debug.NONE);
        SwingUtilities.invokeLater(() -> {
            MainFrame mf = new MainFrame();
            mf.setVisible(true);
        });
    }
}
EOF

# === Create Debug.java with package $PROJECT.Utility ===
cat << EOF > "$PROJECT/src/$PROJECT/Utility/Debug.java"
/* ----------------------------------------------------------------------------------------
 * Debug.java - This utility class provides a simple debugging and logging mechanism. It is
 * designed to give a developer the ability to look behind the scenes of the application
 * and track the flow of execution with errors, warnings and informational messages either
 * printed to the console or written to a log file. The logging can be controlled via a
 * bitmask flag system, allowing the developer to specify which types of message should be
 * shown or logged.
 * ----------------------------------------------------------------------------------------
 * Author:      Patrik Eigenmann
 * eMail:       p.eigenmann@gmx.net
 * GitHub:      https://www.github.com/PatrikEigenmann/$PROJECT
 * ----------------------------------------------------------------------------------------
 * Change Log:
 * $DATE File created.                                              Version: 00.01
 * ---------------------------------------------------------------------------------------- */
package Hangman.Utility;

// Standard Java imports
import java.io.FileWriter;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Debug.java - This utility class provides a simple debugging and logging mechanism. It is
 * designed to give a developer the ability to look behind the scenes of the application
 * and track the flow of execution with errors, warnings and informational messages either
 * printed to the console or written to a log file. The logging can be controlled via a
 * bitmask flag system, allowing the developer to specify which types of message should be
 * shown or logged.
 */
public class Debug {

    /** This bitmask represents Errors  */
    public static final int ERR     = 0b0001;
    
    /** This bitmask represents Warnings  */
    public static final int WARN    = 0b0010;
    
    /** This bitmask represents Infos  */
    public static final int INFO    = 0b0100;
    
    /** This bitmask represents writing to a log file  */
    public static final int FILE    = 0b1000;

    /** This bitmask represents no debugging at all, mostly for release.  */
    public static final int NONE    = 0b0000;
    
    /** This bitmask represent tracking all (Error, Warnings, and Info)  */
    public static final int ALL     = ERR | WARN | INFO;

    /** Default mask is set to ALL  */
    private static int mask = ALL;
    
    /** This is the file path to the log file.  */
    private static final String FILE_PATH = "debug.log";
    
    /** Every debug entry gets a timestamp. Common practice.  */
    private static final DateTimeFormatter timestamp =
        DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    /**
     * Here we initialize the debug utility with a specific mask. It is completely
     * up to the developer to decide which messages should be logged or printed. Combinations
     * of the constants defined above can be used to fine-tune the output.
     * 
     * Examples:
     * <pre>
     * Debug.init(Debug.ERR | Debug.WARN); // Only errors and warnings will be logged.
     * Debug.init(Debug.ALL | Debug.FILE); // All messages will be logged in the file.
     * Debug.init(Debug.NONE);             // No messages will be logged or printed.
     * </pre>
     * 
     * @param debugMask The bitmask that defines which types of messages should be logged or printed.
     */
    public static void init(int debugMask) {
        mask = debugMask;
    }

    /**
     * Calls the core multiplexer for this debugging utility, allowing the developer to log messages
     * with a specific log level and class name. This method formats the message with the class name
     * and the message itself, ensuring that the output is clear and consistent.
     * 
     * @param level The log level (ERR, WARN, INOF) to catogorize the message.
     * @param classname The name of the class from which the message originates.
     * @param msg The actual message to print or log.
     */
    public static void log(int level, String classname, String msg) {
        
        // Marry the class name with the message for consistency in the log output.
        String message = formatClassName(classname) + " " + msg;
        log(level, message);
    }

    /**
     * Acts as the core output multiplexer for this debugging utility. Based on a bitmask configuration,
     * this method conditionally routes messages to the console or a log file (debug.log), enriched
     * with a timestamp and log level. The output respects strict level masking, ensuring only qualified
     * messages are emitted through the selected channel.
     *
     * Developers should call this method directly with the appropriate log level:
     * {@code Debug.log(Debug.ERR, "Message")}, {@code Debug.log(Debug.INFO, "Message")}, etc.
     * 
     * @param level The log level (ERROR, WARN, INFO) to categorize the message.
     * @param msg The actual message to print or log.
     */
    public static void log(int level, String msg) {
        // Only proceed if level is enabled in the mask
        if ((mask & level) == 0) return;

        String output = timestamp.format(LocalDateTime.now()) + " " + formatLabel(level) + " - " + msg;

        if ((mask & FILE) != 0) {
            try (FileWriter writer = new FileWriter(FILE_PATH, true)) {
                writer.write(output + System.lineSeparator());
            } catch (IOException e) {
                // Use the own Debug class to log the error occurred while writing to the log file.
                // Debug.log(Debug.ERR, Debug.class.getSimpleName(), "Failed to write to debug.log: " + e.getMessage());
                // No, I can't do that here, I would create a infinite loop. Fall back to System.out.println();
                System.out.println("Failed to write to debug.log: " + e.getMessage());
            }
        } else {
            System.out.println(output);
        }
    }

    /**
     * Labeling the log message with the appropriate level to ensure clarity in the output.
     * This method is private and used internally to format the log messages.
     * @param level The log level (ERROR, WARN, INFO) to categorize the message.
     * @return A formatted string representing the log level.
     */
    private static String formatLabel(int level) {
        if (level == ERR) return "[ERROR]";
        if (level == WARN) return "[WARN] ";
        if (level == INFO) return "[INFO] ";
        return "[DEBUG]";
    }

    /**
     * Formats the class name for logging purposes. This method is used to ensure
     * the class name is presented in a consistent format in the log messages.
     * 
     * @param classname The name of the class to format.
     * @return A formatted string representing the class name, or a default
     *         value if the input is null or empty.
     */
    private static String formatClassName(String className) {
        // If the class name is null or empty, return a default value
        // to avoid NullPointerException or empty output.
        if (className == null || className.isEmpty()) {
            return "[UnknownClass]";
        }

        // Extract the simple class name from the fully qualified name
        // This is useful to avoid cluttering the log with package names.
        int lastDot = className.lastIndexOf(".");
        
        // If there is no dot, return the class name as is; otherwise, return the
        // substring after the last dot. This ensures we only get the simple class
        // name without the package. This is useful for cleaner log output.
        return "[" + ((lastDot != -1) ? className.substring(lastDot + 1) : className) + "]";
    }
}
EOF

# === Create MainFrame.java with package $PROJECT.Gui ===
cat << EOF > "$PROJECT/src/$PROJECT/Gui/MainFrame.java"
/* ----------------------------------------------------------------------------------------
 * MainFrame.java - Provides the root window and primary GUI container for the application.
 * It manages layout, event routing, and user interaction across core components and is
 * intended to be reused across projects.
 *
 * By encapsulating the UI logic in this class, the application retains a clear separation
 * of concerns between interface and backend logic. This promotes modularity and allows
 * the UI to remain decoupled from specific functionality, making it suitable for Swing
 * applications or future frameworks.
 * ----------------------------------------------------------------------------------------
 * Author:      Patrik Eigenmann
 * eMail:       p.eigenmann@gmx.net
 * GitHub:      https://www.github.com/PatrikEigenmann/$PROJECT
 * ----------------------------------------------------------------------------------------
 * Change Log:
 * $DATE File created.                                              Version: 00.01
 * ---------------------------------------------------------------------------------------- */

package $PROJECT.Gui;

import javax.swing.JFrame;

/**
 * MainFrame.java - Provides the root window and primary GUI container for the application.
 * It manages layout, event routing, and user interaction across core components and is
 * intended to be reused across projects.
 *
 * By encapsulating the UI logic in this class, the application retains a clear separation
 * of concerns between interface and backend logic. This promotes modularity and allows
 * the UI to remain decoupled from specific functionality, making it suitable for Swing
 * applications or future frameworks.
 */
public class MainFrame extends JFrame {

    /**
     * Constructor for the main window. Sets up the user interface: the frequency slider,
     * buttons, and control logic. Wires up the interactions, lays out the components,
     * and initializes defaults. This is where everything visible (and some invisible)
     * gets wired together.
     */
    public MainFrame() {
        super("$PROJECT");
        Debug.log(Debug.INFO, MainFrame.class.getSimpleName(), "Initializing MainFrame...");
        setSize(800, 600);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    }

    /**
     * The main method acts as the starting point of the application. When the program
     * is launched, execution begins here, ensuring that all necessary components are
     * initialized and the user interface is displayed.
     *
     * This method is responsible for setting the application in motion. It ensures
     * that the primary frame is created and rendered within the correct thread
     * context to maintain responsiveness and stability.
     *
     * In structured software design, having a clearly defined entry point allows for
     * predictable execution, making the application easy to manage and extend.
     *
     * @param args Command-line arguments passed during application startup.
     *             These can be used for configuration or debugging but are
     *             typically not required in standard executions.
     */
    public static void main(String[] args) {
        Debug.init(Debug.ALL);
        SwingUtilities.invokeLater(() -> {
            MainFrame mf = new MainFrame();
            mf.setVisible(true);
        });
    }
}
EOF

# === Create README.md ===
cat << EOF > "$PROJECT/README.md"
# $PROJECT

## About

## About

Please describe your project here.

This section is intended to give a short overview of your application's purpose, scope, and key features. Try to keep it concise and informative.

## Folder Structure

\`\`\`
$PROJECT/
├── bin/                           ← Output: packaged .jar files  
├── build/                         ← Compiled .class files from source  
├── lib/                           ← External libraries manually tracked  
├── manifest/                      ← Jar manifest file for Main-Class and classpath  
│   └── MANIFEST.MF                ← Declares entry point and classpath  
├── scripts/                       ← Cross-platform build tools  
│   ├── compile.cmd                ← Windows: compiles .java files into /build  
│   ├── compile.sh                 ← Unix: compiles .java files into /build  
│   ├── run.cmd                    ← Windows: launches App class with dependencies  
│   ├── run.sh                     ← Unix: launches App class with dependencies  
│   ├── pack.cmd                   ← Windows: creates executable .jar using manifest  
│   └── pack.sh                    ← Unix: creates executable .jar using manifest  
├── src/                           ← Source code directory
│   ├── App.java                   ← Entry point (default package)  
│   └── $PROJECT/                  ← Project-specific source code
│       ├── Gui/                   ← GUI container for layout, controls, and logging
│       │   └── MainFrame.java     ← Main application window with layout and controls
│       └── Utility/               ← Utility classes useful across the project
│           └── Debug.java         ← Debugging utility for logging and error tracking  
├── LICENSE                        ← GNU General Public License v3.0  
├── README.md                      ← Project overview and usage instructions  
└── .gitignore                     ← Build hygiene and repo clarity
\`\`\`

## Author

Hello, my name is **Patrik Eigenmann**. I spent nine years as a software engineer working with Java and C# on server-side backend projects. Along the way, I picked up PHP, HTML, and CSS. Later I pivoted to audio—now I work full-time as a Sound Engineer and production manager for large-scale corporate and private live events.

Even now, I still write software in C and Java, especially GUI applications. It’s a passion I never dropped. Programming helps me reflect, learn, and structure my thoughts about how the world works. Most of my projects come from real-world needs.

If you find this project useful, consider donating a few bucks via [PayPal](mailto:p.eigenmann@gmx.net). I appreciate every small contribution—it encourages me to keep developing practical, usable tools that solve real problems.

Thanks for checking out my repo. I hope it helps you.

## License

This project is licensed under the [GNU GPL v3.0](https://www.gnu.org/licenses/gpl-3.0.txt). Feel free to explore, modify, and use responsibly.
EOF

# === Create .gitignore ===
cat << EOF > "$PROJECT/.gitignore"
.vscode/
bin/
*.exe
*.dll
*.so
*.dylib
*.jar
!lib/*.dll
!lib/*.so
!lib/*.dylib
!lib/*.jar
build/
*.class
*.o
*.obj
.DS_Store
sources.txt
EOF

# === Create MANIFEST.MF ===
cat << EOF > "$PROJECT/manifest/MANIFEST.MF"
Manifest-Version: 1.0
Main-Class: App
EOF

# === Copy LICENSE ===
cp GPL-3.0.txt "$PROJECT/LICENSE"

# === Create compile.sh ===
cat << EOF > "$PROJECT/scripts/compile.sh"
#!/bin/bash
find ./src -name "*.java" > sources.txt && javac -d build @sources.txt
EOF
chmod +x "$PROJECT/scripts/compile.sh"

# === Create compile.cmd ===
cat << EOF > "$PROJECT/scripts/compile.cmd"
@echo off
dir /s /b src\\*.java > sources.txt
javac -d build @sources.txt
EOF

# === Create run.sh ===
cat << EOF > "$PROJECT/scripts/run.sh"
#!/bin/bash
java -cp build:lib:bin App
EOF
chmod +x "$PROJECT/scripts/run.sh"

# === Create run.cmd ===
cat << EOF > "$PROJECT/scripts/run.cmd"
@echo off
java -cp build;lib;bin App
EOF

# === Create pack.sh ===
cat << EOF > "$PROJECT/scripts/pack.sh"
#!/bin/bash
jar cfm bin/$PROJECT.jar manifest/MANIFEST.MF -C build .
EOF
chmod +x "$PROJECT/scripts/pack.sh"

# === Create pack.cmd ===
cat << EOF > "$PROJECT/scripts/pack.cmd"
@echo off
jar cfm bin\\$PROJECT.jar manifest\\MANIFEST.MF -C build .
EOF

echo "✅ '$PROJECT' scaffolded successfully with full structure, headers, documentation, and reusable components."

cd "$PROJECT"

git init
git add .
git commit -m "First time commiting $PROJECT"
git branch -M main
git remote add origin https://github.com/PatrikEigenmann/$PROJECT.git
git push -u origin main
echo "✅ Git repository initialized and first commit created."
