param (
    [Parameter(Mandatory = $true)]
    [string]$Project
)

$Date = Get-Date -Format "ddd yyyy-MM-dd"
Write-Host "📦 Initializing Java project: $Project"

# === Append project folder to local .gitignore ===
$gitignore = ".gitignore"
$entry = "/$Project/"

if (Test-Path $gitignore) {
    $lines = Get-Content $gitignore
    if ($lines.Count -gt 0 -and -not ($lines[-1] -match '^\s*$')) {
        Add-Content $gitignore "`n"
    }
    if (-not ($lines -contains $entry)) {
        Add-Content $gitignore $entry
        Write-Host "📄 Added '$entry' to local .gitignore"
    }
}

# === Create folder structure ===
New-Item -ItemType Directory -Path "$Project/bin","$Project/build","$Project/lib","$Project/manifest","$Project/scripts","$Project/src/$Project/Gui" | Out-Null

# === Create App.java ===
@"
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
 * GitHub:      https://www.github.com/PatrikEigenmann/$Project
 * -------------------------------------------------------------------------------
 * Change Log:
 * $Date File created.                                     Version: 00.01
 * ------------------------------------------------------------------------------- */

/* Javax Swing SwingUtilities import */ 
import javax.swing.SwingUtilities;

/* $Project Gui MainFrame import */
import $Project.Gui.MainFrame;

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
        SwingUtilities.invokeLater(() -> {
            MainFrame mf = new MainFrame();
            mf.setVisible(true);
        });
    }
}
"@ | Set-Content "$Project/src/App.java"

# === Create MainFrame.java ===
@"
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
 * GitHub:      https://www.github.com/PatrikEigenmann/$Project
 * ----------------------------------------------------------------------------------------
 * Change Log:
 * $Date File created.                                              Version: 00.01
 * ---------------------------------------------------------------------------------------- */

package $Project.Gui;

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
        super("$Project");
        setSize(800, 600);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    }
}
"@ | Set-Content "$Project/src/$Project/Gui/MainFrame.java"

# === Copy LICENSE ===
Copy-Item "GPL-3.0.txt" -Destination "$Project/LICENSE"

# === Create MANIFEST.MF ===
@"
Manifest-Version: 1.0
Main-Class: App
"@ | Set-Content "$Project/manifest/MANIFEST.MF"

# === Create .gitignore ===
@"
.vscode/
bin/
*.exe
*.dll
*.so
*.dylib
*.jar
!lib/*.jar
build/
*.class
*.obj
.DS_Store
sources.txt
"@ | Set-Content "$Project/.gitignore"

# === Create scripts ===
@"
@echo off
dir /s /b src\*.java > sources.txt
javac -d build @sources.txt
"@ | Set-Content "$Project/scripts/compile.cmd"

@"
@echo off
java -cp build;lib;bin App
"@ | Set-Content "$Project/scripts/run.cmd"

@"
@echo off
jar cfm bin\$Project.jar manifest\MANIFEST.MF -C build .
"@ | Set-Content "$Project/scripts/pack.cmd"

@"
#!/bin/bash
find ./src -name \"*.java\" > sources.txt && javac -d build @sources.txt
"@ | Set-Content "$Project/scripts/compile.sh"

@"
#!/bin/bash
java -cp build:lib:bin App
"@ | Set-Content "$Project/scripts/run.sh"

@"
#!/bin/bash
jar cfm bin/$Project.jar manifest/MANIFEST.MF -C build .
"@ | Set-Content "$Project/scripts/pack.sh"

# === Create README.md ===
@"
# $Project

## About

## About

Please describe your project here.

This section is intended to give a short overview of your application's purpose, scope, and key features. Try to keep it concise and informative.

## Folder Structure

\`\`\`
$Project/
├── bin/                           ← Output: packaged .jar files  
├── build/                         ← Compiled .class files from source  
├── lib/                           ← External libraries manually tracked  
├── manifest/
│   └── MANIFEST.MF                ← Declares entry point and classpath  
├── scripts/
│   ├── compile.cmd                ← Windows: compiles .java files into /build  
│   ├── compile.sh                 ← Unix: compiles .java files into /build  
│   ├── run.cmd                    ← Windows: launches App class with dependencies  
│   ├── run.sh                     ← Unix: launches App class with dependencies  
│   ├── pack.cmd                   ← Windows: creates executable .jar using manifest  
│   └── pack.sh                    ← Unix: creates executable .jar using manifest  
├── src/
│   ├── App.java                   ← Entry point (default package)  
│   └── $Project/Gui/
│       └── MainFrame.java         ← GUI container for layout, controls, and logging  
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
"@ | Set-Content "$Project/README.md"

Write-Host "✅ '$Project' scaffolded successfully with full structure, headers, documentation, and reusable components."

Set-Location "$Project"

git init
git add .
git commit -m "First time commiting $Project"
git branch -M main
git remote add origin https://github.com/PatrikEigenmann/$Project.git
git push -u origin main
Write-Host "✅ Git repository initialized and first commit created."
