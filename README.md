# Windows-AI-C-CPP-IDE-Pro
**Performance you can feel, Simplicity you will Appreciate**

A professional, AI-powered integrated development environment designed specifically for learning C and C++ programming. Generate code from natural language descriptions, compile with built-in GCC, and get voice-powered explanations - all in one beautiful Windows application.

## 📋 Features

### 🤖 AI-Powered Code Generation
- **Natural Language to Code** - Describe your problem in plain English, get working C/C++ code
- **Smart Language Detection** - Automatically identifies whether you need C or C++ based on your prompt
- **NVIDIA AI Integration** - Powered by Llama-3-70B for high-quality code generation
- **Context-Aware** - Generates complete programs with proper structure, input validation, and error handling

### 🛠️ Complete Development Environment
- **Built-in GCC Compiler** - No separate installation needed (compiler bundled with application)
- **One-Click Compilation** - Compile your generated code instantly
- **Integrated Execution** - Run programs with automatic input detection and handling
- **Real-Time Output** - See program output as it executes

### 🔊 Voice Learning System
- **IGRF-Bhramha (Male)** - Professional male voice
- **IGRF-Saraswathi (Female)** - Professional female voice
- **Voice Explanations** - Code, algorithms, and output explained verbally
- **Smart Input Prompts** - Voice announces what input is needed
- **Result Announcements** - Program results read aloud for better learning

### 📊 Educational Tools
- **Step-by-Step Algorithm** - Visual algorithm display alongside code
- **Code Explanation** - Detailed explanation of how the code works
- **Input Detection** - Automatically identifies required inputs from code
- **Validation Analysis** - Checks if code follows proper structure

### 🎨 Professional Windows 11 UI
- **Clean, Modern Interface** - Split view with code and output panels
- **Color-Coded Sections** - Easy visual separation of different areas
- **Real-Time Status** - Compiler, AI, and voice status always visible
- **Scrolling Tips** - Educational tips scroll continuously in header
- **Keyboard Shortcuts** - Quick access to all features

## 🔧 Requirements

- **OS:** Windows 7/8/10/11 (32/64-bit)
- **Framework:** .NET Framework 4.5 or higher
- **PowerShell:** Version 5.1 or higher
- **Storage:** ~200 MB (includes bundled GCC compiler)
- **Internet:** Required for AI code generation (NVIDIA API)
- **Speech:** Windows Speech API (built-in) for voice features

## ⚡ Quick Start

# For compiled EXE version (if available)
AI-C-C++IDE-Pro_Setup.exe - Run as administrator.

## 📖 How to Use

### 1. Describe Your Problem
- Type your programming problem in natural language
- **Examples:**
  - "Write a C program to add two numbers"
  - "Create a C++ program to calculate factorial"
  - "Write code to check if a number is prime in C"
- The IDE automatically detects if you need C or C++

### 2. Generate Code
- Press **Enter** or click **GENERATE**
- AI generates complete code with:
  - Proper header includes
  - Input validation
  - Clear variable names
  - Comments explaining logic
- Code appears in the left panel with syntax highlighting

### 3. Review Algorithm & Explanation
- Switch to **Algorithm** tab to see step-by-step logic
- Switch to **Code Explanation** tab for detailed breakdown
- Use **EXPLAIN** buttons to hear voice explanations

### 4. Compile & Run
- Click **COMPILE** - Built-in GCC compiler checks your code
- Click **RUN** - Program executes with automatic input detection
- Enter values when prompted (voice announces each prompt)
- See results in Console Output tab
- Hear results read aloud for better understanding

### 5. Voice Controls
- **EXPLAIN** - Speak the current tab's content
- **STOP** - Stop ongoing voice announcement
- **Voice Menu** - Switch between male/female voices
- Voice automatically announces:
  - Input prompts when running
  - Program output and results
  - Compilation success/failure
  - Code generation status

## ⌨️ Keyboard Shortcuts

**Enter** | Generate code (when in problem textbox) 
**Ctrl+S** | Save generated code 
**Ctrl+D** | Toggle debug mode 
**Voice Menu** | Switch voices via menu 

## 🎯 Example Workflow

**Problem:** "Write a C++ program to calculate factorial"

1. Type the problem in the description box
2. Press **Enter** or click **GENERATE**
3. AI generates complete factorial program with:
   - Input validation for non-negative numbers
   - Clear prompts
   - Proper calculation logic
4. Click **COMPILE** to verify
5. Click **RUN** to execute
6. Enter a number when prompted (voice says "Enter a non-negative integer for factorial calculation")
7. See and hear the result: "Factorial of 5: 120"

## 🎨 UI Sections

### Header Panel
- **Logo & Title** - IGRF AI C/C++ IDE Pro
- **Language Detection** - Shows detected language (C/C++)
- **Status Indicators** - AI, Compiler, Voice status
- **Scrolling Tips** - Educational messages

### Input Panel
- Problem description textbox with placeholder
- Press Enter to generate code

### Button Panel
- **GENERATE** - Create code from description
- **COMPILE** - Compile with GCC
- **RUN** - Execute program
- **CLEAR** - Reset all panels

### Code Panel (Left)
- **Source Code Tab** - Generated code with syntax highlighting
- **Algorithm Tab** - Step-by-step algorithm
- **Voice Controls** - Explain/Stop buttons

### Output Panel (Right)
- **Console Output Tab** - Program execution output
- **Code Explanation Tab** - Detailed explanation
- **Voice Controls** - Explain/Stop buttons

### Status Bar
- Current status
- AI connection state
- Split ratio
- Session count
- Date/time
- Developer link

## 🧠 AI Code Generation Details

- **Proper input collection** - All inputs requested before calculations
- **Clear prompts** - Each input has a descriptive prompt
- **Input validation** - Checks for invalid data types and values
- **Error handling** - Graceful error messages and exit codes
- **Comment documentation** - Code is well-commented for learning
- **Language-appropriate syntax** - C or C++ as specified

## 📁 Directory Structure

IGRF_AI_C-CPP_IDE_Pro\
├── AI-C-C++IDE_Main.ps1          # Main application script
├── gcc\                          # Bundled GCC compiler
│   └── bin\gcc.exe               # GCC compiler executable
├── Logo.png                       # Application logo
├── Icon.ico                        # Application icon
└── README.md                       # This file

Temporary files are created in:

%TEMP%\IGRF_IDE_[random]\[random].c/.cpp
%TEMP%\IGRF_IDE_[random]\[random].exe

## ⚠️ Important Notes

### Antivirus Considerations
This application creates temporary files and processes for compiling C/C++ code, which may trigger antivirus alerts. These are legitimate educational operations required for IDE functionality. If your antivirus flags this application, please add exclusions for:
- The installation folder
- PowerShell process
- `%TEMP%\IGRF_IDE\*` folder

### Internet Connection
- **Required** for AI code generation
- Works offline for compilation and running existing code
- Voice features work offline

### API Key
The application includes a API key and in the program code your own generated API Key.

## 📊 Version History

**v1.0 (Current)**
- AI-powered C/C++ code generation
- Built-in GCC compiler
- Voice explanations (male/female)
- Automatic input detection
- Algorithm visualization
- Code explanation panel
- Professional Windows 11 UI
- Scrolling educational tips
- Real-time status indicators
- Comprehensive error handling
- Keyboard shortcuts
- IGRF branding with logo/icon
- Secure temp file management
- Event logging for troubleshooting

**IGRF AI C/C++ IDE Pro v1.0**  
*Performance you can feel, Simplicity you will Appreciate*

© 2026 IGRF Pvt. Ltd. All rights reserved.
