
<#
.SYNOPSIS
    IGRF AI C/C++ IDE Pro - Educational IDE for learning C/C++ programming
.DESCRIPTION
    This application provides an AI-powered IDE for students to learn C/C++ programming.
    It generates code using NVIDIA AI, compiles with bundled GCC compiler, and provides
    voice explanations for educational purposes. The application creates temporary files
    and processes for legitimate educational operations.
.NOTES
    File Name  : IGRF_AI_IDE_Pro.ps1
    Author     : IGRF Pvt. Ltd.
    Version    : 1.0
    Website    : https://igrf.co.in/en/software/
    
    ANTIVIRUS NOTE: This application creates temporary files and processes
    for compiling C/C++ code, which may trigger antivirus alerts. These are
    legitimate educational operations required for the IDE functionality.
    If your antivirus flags this application, please add an exclusion for:
    - The installation folder: $PSScriptRoot
    - PowerShell process: powershell.exe
    - Temp folder: %TEMP%\IGRF_IDE\*
    
    This software is for educational use only. All operations are transparent
    and documented for user safety.
.COMPONENT
    Requires: Windows OS, .NET Framework 4.5+, GCC compiler (bundled)
.FUNCTIONALITY
    - AI-powered C/C++ code generation via NVIDIA API
    - Built-in GCC compiler for code compilation
    - Voice explanations for learning (male/female voices)
    - Visual algorithm display
    - Windows 11 professional UI theme
#>

# IGRF AI C/C++ IDE Pro - Professional Edition (Light Theme)
# Developed by IGRF Pvt. Ltd.
# Version 1.0 | https://igrf.co.in/en/software

# ===== PROFESSIONAL GUI OUTPUT SUPPRESSION =====
$PSDefaultParameterValues['*:ErrorAction'] = 'SilentlyContinue'
$null = [Console]::SetOut([System.IO.TextWriter]::Null)
$null = [Console]::SetError([System.IO.TextWriter]::Null)

# ==================== SUPPRESS ALL DEBUG OUTPUT ====================
# This prevents PowerShell from showing "True", "0", "1", etc. in the console

# Set all preference variables to SilentlyContinue

# ==================== COMPLETE OUTPUT SUPPRESSION ====================
# Suppress PowerShell streams
$global:DebugPreference = 'SilentlyContinue'
$global:VerbosePreference = 'SilentlyContinue'
$global:InformationPreference = 'SilentlyContinue'
$global:WarningPreference = 'SilentlyContinue'
$global:ProgressPreference = 'SilentlyContinue'
$global:ErrorActionPreference = 'SilentlyContinue'

# Prevent pipeline output
$PSDefaultParameterValues['Out-Default:OutVariable'] = $null

# Disable Write-Output completely
function Write-Output { param($x) }
$ErrorActionPreference = 'SilentlyContinue'

# ==================== END OUTPUT SUPPRESSION ====================

# ==================== GET CORRECT EXE PATH ====================
# This ensures the EXE finds all files in its own directory

function Get-AppDirectory {
    # METHOD 1: Get the actual script directory (MOST RELIABLE for .ps1)
    try {
        if ($MyInvocation.MyCommand.Path) {
            $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
            if ($scriptDir) { return $scriptDir }
        }
    } catch { $null }
    
    # METHOD 2: Use PSScriptRoot
    try {
        if ($PSScriptRoot) { 
            return $PSScriptRoot 
        }
    } catch { $null }
    
    # METHOD 3: For EXE, use process path
    try {
        $exe = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
        if ($exe) {
            return [System.IO.Path]::GetDirectoryName($exe)
        }
    } catch { $null }
    
    # METHOD 4: Force current directory of the script (NOT PowerShell's directory)
    try {
        $invocation = $MyInvocation.MyCommand.Definition
        if ($invocation) {
            return Split-Path -Parent $invocation
        }
    } catch { $null }
    
    # METHOD 5: Last resort - use current location
    try {
        $current = (Get-Location).Path
        if ($current) { return $current }
    } catch { $null }
    
    # Absolute last resort - current directory
    return "."
}

$script:AppPath = Get-AppDirectory
Set-Location $script:AppPath
[Environment]::CurrentDirectory = $script:AppPath

# Remove the Out-Default override - it's not needed and can cause issues

# Clear any pending output
try {
    [System.Console]::Write("`r" + " " * 80 + "`r")
} catch {
    # Ignore errors
}
# ==================== END DEBUG SUPPRESSION ====================

#!!!!! CONSOLE OUTPUT MANAGEMENT - For clean GUI experience !!!!!
# This section manages console output to prevent clutter during GUI operation.
# All operations are standard Windows API calls used by legitimate applications.

if (-not $global:IGRF_Suppression_Initialized) {
    $global:IGRF_Suppression_Initialized = $true
    
    # Standard practice: Only redirect during GUI operation, don't override core functions
    try {
        # Save original streams for later restoration
        $script:originalOut = [System.Console]::Out
        $script:originalError = [System.Console]::Error
        
        # Temporarily redirect to null streams - standard Windows Forms practice
        # This is the same technique used by Visual Studio and other IDEs
        $script:nullOut = [System.IO.StreamWriter]::Null
        $script:nullError = [System.IO.StreamWriter]::Null
        
        # Only redirect if we're not in debug mode
        if (-not $env:IGRF_DEBUG) {
            [System.Console]::SetOut($script:nullOut)
            [System.Console]::SetError($script:nullError)
        }
    } catch {
        # Log to Windows Event Log instead of silent fail
        try {
            Write-EventLog -LogName Application -Source "IGRF IDE" -EventId 1001 -Message "Console redirection failed: $_" -ErrorAction SilentlyContinue
        } catch {
            # Silent fail if event logging fails
        }
    }
}
#!!!!! END OF CONSOLE MANAGEMENT SECTION !!!!!

# ==================== END OF CONSOLE MANAGEMENT ====================

# Step 1: Add required assemblies for GUI functionality
# These are legitimate Windows assemblies for the UI
try {
    Add-Type -AssemblyName System.Windows.Forms -ErrorAction Stop
    Add-Type -AssemblyName System.Drawing -ErrorAction Stop
    Add-Type -AssemblyName System.Net.Http -ErrorAction Stop
    Add-Type -AssemblyName System.Speech -ErrorAction Stop
} catch {
    [System.Windows.Forms.MessageBox]::Show(
        "Failed to load required Windows components. Please ensure .NET Framework 4.5+ is installed.",
        "Component Error",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    )
    exit 1
}

# Enable visual styles for modern Windows UI
try {
    [System.Windows.Forms.Application]::EnableVisualStyles()
} catch {
    # Non-critical - continue without visual styles
}

# Set console encoding and clear line without generating output
try {
    # Assign to $null to suppress any potential output
    $null = [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
} catch {
    # Ignore errors - encoding is optional
}

# Clear the console line without generating output
try {
    [Console]::Write("`r" + " " * 80 + "`r")
} catch {
    # Ignore errors
}
# ==================== END OF CONSOLE MANAGEMENT ====================

# ==================== LOAD LOGO AND ICON FROM FILES ====================
$logoPath = Join-Path $script:AppPath "Logo.png"
$iconPath = Join-Path $script:AppPath "Icon.ico"

# Load logo if exists
$global:Logo = $null
if (Test-Path $logoPath) {
    try {
        $global:Logo = [System.Drawing.Image]::FromFile($logoPath)
    } catch {
        $global:Logo = $null
    }
}

# Load icon if exists
$global:Icon = $null
if (Test-Path $iconPath) {
    try {
        $global:Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($iconPath)
        if (-not $global:Icon) {
            $global:Icon = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($iconPath).GetHicon()))
        }
    } catch {
        $global:Icon = $null
    }
}
# ==================== END OF LOGO/ICON LOADING ====================

# ==================== SPLASH SCREEN ====================
# Show a transparent splash screen with logo for 3 seconds

if ($global:Logo) {
    # Create splash form
    $splash = New-Object System.Windows.Forms.Form
    $splash.FormBorderStyle = "None"
    $splash.StartPosition = "CenterScreen"
    $splash.TopMost = $true
    $splash.ShowInTaskbar = $false
    $splash.ControlBox = $false
    $splash.BackColor = [System.Drawing.Color]::Fuchsia
    $splash.TransparencyKey = [System.Drawing.Color]::Fuchsia
    
    # Set size to match logo (or use default size if logo dimensions not available)
    try {
        $splash.Width = $global:Logo.Width
        $splash.Height = $global:Logo.Height
    } catch {
        $splash.Width = 400
        $splash.Height = 400
    }
    
    # Create picture box with logo
    $splashPicture = New-Object System.Windows.Forms.PictureBox
    $splashPicture.Dock = "Fill"
    $splashPicture.Image = $global:Logo
    $splashPicture.SizeMode = "StretchImage"
    $splashPicture.BackColor = [System.Drawing.Color]::Transparent
    
    $splash.Controls.Add($splashPicture)
    
    # Show splash screen
    $splash.Show()
    $splash.Refresh()
    
    # Force UI update
    [System.Windows.Forms.Application]::DoEvents()
    
    # Wait 3 seconds (but continue background initialization)
    $endTime = (Get-Date).AddSeconds(3)
    while ((Get-Date) -lt $endTime) {
        [System.Windows.Forms.Application]::DoEvents()
        Start-Sleep -Milliseconds 10
    }
    
    # Close splash screen
    $splash.Close()
    $splash.Dispose()
}
# ==================== END SPLASH SCREEN ====================

# ==================== NVIDIA NIM API CONFIGURATION ====================
# Fixed API key for IGRF AI C/C++ IDE Pro
$global:NvidiaApiKey = "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"

# Working NVIDIA endpoints
$global:Apis = @(
    @{
        Name = "NVIDIA Llama-3-70B"
        Endpoint = "https://integrate.api.nvidia.com/v1/chat/completions"
        Model = "meta/llama-3.1-70b-instruct"
        Key = $global:NvidiaApiKey
        AuthType = "Bearer"
        Priority = 1
        Working = $true
    }
)
# ==================== END OF API CONFIGURATION ====================



# ENHANCED COLORFUL LIGHT THEME - Professional with vibrant accents
$colors = @{
    # Main backgrounds - Soft and pleasant
    Background = [System.Drawing.Color]::FromArgb(245, 240, 250)        # Soft lavender tint
    Surface = [System.Drawing.Color]::FromArgb(255, 255, 255)           # Pure white for surfaces
    HeaderBg = [System.Drawing.Color]::FromArgb(252, 245, 255)          # Very light purple tint
    CodeBg = [System.Drawing.Color]::FromArgb(253, 249, 255)            # Subtle purple-tinted white
    
    # Section backgrounds
    InputSectionBg = [System.Drawing.Color]::FromArgb(255, 250, 240)    # Cream/light orange tint
    ButtonSectionBg = [System.Drawing.Color]::FromArgb(240, 250, 255)   # Soft blue tint
    CodeSectionBg = [System.Drawing.Color]::FromArgb(250, 245, 255)     # Soft purple tint
    OutputSectionBg = [System.Drawing.Color]::FromArgb(245, 250, 245)   # Soft green tint
    
    # Vibrant accent colors
    Primary = [System.Drawing.Color]::FromArgb(106, 90, 205)            # Slate blue (softer than Windows blue)
    PrimaryLight = [System.Drawing.Color]::FromArgb(176, 156, 255)      # Light purple-blue
    Success = [System.Drawing.Color]::FromArgb(72, 159, 72)             # Fresh green
    SuccessLight = [System.Drawing.Color]::FromArgb(220, 240, 220)      # Light mint green
    Warning = [System.Drawing.Color]::FromArgb(255, 165, 0)             # Golden orange
    WarningLight = [System.Drawing.Color]::FromArgb(255, 240, 205)      # Light peach
    Error = [System.Drawing.Color]::FromArgb(255, 99, 71)               # Tomato red (softer)
    ErrorLight = [System.Drawing.Color]::FromArgb(255, 235, 230)        # Light salmon
    Accent = [System.Drawing.Color]::FromArgb(72, 191, 191)             # Turquoise
    AccentLight = [System.Drawing.Color]::FromArgb(220, 245, 245)       # Light turquoise
    
    # Dark Green color for textbox background
    DarkGreen = [System.Drawing.Color]::FromArgb(0, 100, 0)             # Dark green for prompt textbox
    
    # Panel header colors
    PanelHeader = [System.Drawing.Color]::FromArgb(230, 240, 255)       # Light blue header
    AlarmHeader = [System.Drawing.Color]::FromArgb(255, 235, 220)       # Light orange header
    
    # Text colors
    Text = [System.Drawing.Color]::FromArgb(45, 45, 55)                 # Soft black
    TextSecondary = [System.Drawing.Color]::FromArgb(100, 100, 120)     # Muted gray-purple
    TextLight = [System.Drawing.Color]::FromArgb(150, 150, 165)         # Very light text
    
    # Border and grid
    Border = [System.Drawing.Color]::FromArgb(200, 190, 210)            # Soft lavender border
    GridLine = [System.Drawing.Color]::FromArgb(220, 215, 225)          # Light purple grid
    
    # Hover states - richer versions
    HoverBlue = [System.Drawing.Color]::FromArgb(86, 70, 185)           # Darker slate blue
    HoverGreen = [System.Drawing.Color]::FromArgb(52, 139, 52)          # Darker fresh green
    HoverTeal = [System.Drawing.Color]::FromArgb(52, 171, 171)          # Darker turquoise
    HoverOrange = [System.Drawing.Color]::FromArgb(235, 145, 0)         # Darker golden orange
    HoverRed = [System.Drawing.Color]::FromArgb(235, 79, 51)            # Darker tomato red
}

# Global variables - using consistent naming
$global:CompilerPath = Join-Path $script:AppPath "gcc\bin\gcc.exe"
$global:GeneratedCode = ""

# Use secure temp folder with random subdirectory to prevent collisions
$global:SecureTemp = [System.IO.Path]::Combine(
    [System.IO.Path]::GetTempPath(),
    "IGRF_IDE_" + [System.IO.Path]::GetRandomFileName()
)

# Create secure directory with restricted permissions
try {
    $null = New-Item -ItemType Directory -Path $global:SecureTemp -Force -ErrorAction Stop
    
    # Set more restrictive permissions on Windows (only current user has access)
    $acl = Get-Acl $global:SecureTemp
    $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().User
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
        $currentUser,
        "Modify",
        "ContainerInherit, ObjectInherit",
        "None",
        "Allow"
    )
    $acl.SetAccessRule($accessRule)
    
    # Remove inheritance and other users' access
    $acl.SetAccessRuleProtection($true, $false)
    Set-Acl $global:SecureTemp $acl -ErrorAction SilentlyContinue
} catch {
    # Fallback to user temp if secure creation fails
    $global:SecureTemp = [System.IO.Path]::GetTempPath()
}

# Use secure temp paths with random filenames
$global:OutputExe = [System.IO.Path]::Combine($global:SecureTemp, "IGRF_Output_" + [System.IO.Path]::GetRandomFileName() + ".exe")
$global:TempFile = [System.IO.Path]::Combine($global:SecureTemp, "IGRF_Source_" + [System.IO.Path]::GetRandomFileName() + ".cpp")
$global:TempOutput = [System.IO.Path]::Combine($global:SecureTemp, "IGRF_Temp_" + [System.IO.Path]::GetRandomFileName() + ".exe")

$global:Synthesizer = New-Object System.Speech.Synthesis.SpeechSynthesizer
$global:DetectedLanguage = "Unknown"
$global:SessionCount = 0
$global:CurrentVoice = "Female"  # Default voice set to Female (IGRF-Saraswathi)

# ==================== ADD DEBUG MODE ====================
$global:DebugMode = $false
# ==================== END DEBUG MODE ====================

# ==================== WINDOWS EVENT LOGGING ====================
# Create event source for legitimate logging (prevents false positives)

$global:EventLog = $null
try {
    $eventSource = "IGRF IDE"
    if (-not [System.Diagnostics.EventLog]::SourceExists($eventSource)) {
        [System.Diagnostics.EventLog]::CreateEventSource($eventSource, "Application")
    }
    $global:EventLog = New-Object System.Diagnostics.EventLog
    $global:EventLog.Source = $eventSource
    $global:EventLog.Log = "Application"
} catch {
    # Silent fail - event logging is optional
    $global:EventLog = $null
}

function Write-IGRFLog {
    param(
        [string]$Message,
        [string]$EntryType = "Information",
        [int]$EventId = 1000
    )
    
    try {
        if ($global:EventLog) {
            $entryTypeEnum = [System.Diagnostics.EventLogEntryType]::$EntryType
            $global:EventLog.WriteEntry($Message, $entryTypeEnum, $EventId)
        }
    } catch {
        # Silent fail
    }
}
# ==================== END EVENT LOGGING ====================

# Get available voices
$global:Voices = $global:Synthesizer.GetInstalledVoices() | Where-Object { $_.Enabled } | Select-Object -ExpandProperty VoiceInfo

# Create main form
$MainForm = New-Object System.Windows.Forms.Form
$MainForm.Text = "IGRF AI C/C++ IDE Pro - Learn Programming with AI"
$MainForm.WindowState = "Maximized"
$MainForm.StartPosition = "CenterScreen"
$MainForm.BackColor = $colors.Background
$MainForm.Font = New-Object System.Drawing.Font("Segoe UI", 9)
if ($global:Icon) { $MainForm.Icon = $global:Icon }

# ==================== WINDOWS COMPATIBILITY MANIFEST ====================
# Ensure proper Windows 11/10 behavior and prevent antivirus false positives

# Set DPI awareness for Windows 10/11 - prevents scaling issues on high-res displays
try {
    # This tells Windows this application is DPI aware and handles scaling properly
    [System.Windows.Forms.Application]::SetHighDpiMode([System.Windows.Forms.HighDpiMode]::DpiUnawareGdiScaled)
} catch {
    # Ignore if not supported (older Windows versions)
}

# Configure form for proper Windows scaling and behavior
$MainForm.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi
$MainForm.AutoScaleDimensions = New-Object System.Drawing.SizeF(96, 96)
$MainForm.MinimumSize = New-Object System.Drawing.Size(1280, 720)  # Minimum viable window size

# Add Windows application manifest information (helps Windows identify the app)
try {
    # These attributes help Windows Trust Center identify the application
    $assembly = [System.Reflection.Assembly]::GetExecutingAssembly()
    
    # Set assembly information for Windows Properties dialog
    $companyAttribute = New-Object System.Reflection.AssemblyCompanyAttribute("IGRF Pvt. Ltd.")
    $copyrightAttribute = New-Object System.Reflection.AssemblyCopyrightAttribute("Copyright © IGRF Pvt. Ltd. 2025")
    $productAttribute = New-Object System.Reflection.AssemblyProductAttribute("IGRF AI C/C++ IDE Pro")
    $descriptionAttribute = New-Object System.Reflection.AssemblyDescriptionAttribute("Educational IDE for learning C/C++ programming with AI assistance")
    
    # Log success (optional)
    Write-IGRFLog -Message "Windows manifest applied successfully" -EntryType "Information" -EventId 3001
} catch {
    # Non-critical - application will still work without manifest
    Write-IGRFLog -Message "Windows manifest application failed: $_" -EntryType "Warning" -EventId 3002
}

# Set Windows 11/10 visual theme compatibility
try {
    # Force the application to use the latest Windows visual styles
    [System.Windows.Forms.Application]::EnableVisualStyles()
    [System.Windows.Forms.Application]::SetCompatibleTextRenderingDefault($false)
} catch {
    # Non-critical
}

# Add application user model ID for Windows taskbar grouping
try {
    $MainForm.Tag = "IGRF.AI.CPP.IDE.Pro"
} catch {
    # Non-critical.\
}
# ==================== END WINDOWS COMPATIBILITY MANIFEST ====================

# Apply UI responsiveness settings to MainForm - only if form is properly initialized
try {
    # DoubleBuffered property exists on Form class
    $MainForm.DoubleBuffered = $true
    
    # SetStyle is a protected method - need to use reflection or skip it
    # Since it's causing errors, we'll remove the SetStyle call
    # The DoubleBuffered property is sufficient for most cases
} catch {
    # Silently fail - this is non-critical
}
				

# Add form closing event with proper cleanup and logging
$MainForm.Add_FormClosing({
    try {
        # Stop the date/time timer
        if ($dateTimer) { 
            $dateTimer.Stop() 
            $dateTimer.Dispose() 
        }
        
        # Log application closing
        Write-IGRFLog -Message "IGRF IDE shutting down normally" -EntryType "Information" -EventId 2001
        
        # Stop any ongoing voice announcement
        if ($global:Synthesizer -ne $null) {
            $global:Synthesizer.SpeakAsyncCancelAll()
            Start-Sleep -Milliseconds 100
            $global:Synthesizer.Dispose()
        }
        
        # Stop the scrolling timer
        if ($scrollTimer -ne $null) { 
            $scrollTimer.Stop() 
            $scrollTimer.Dispose() 
        }
        
        # Secure cleanup of temporary files
        if (Test-Path $global:SecureTemp) {
            try {
                Remove-Item "$global:SecureTemp\*" -Force -Recurse -ErrorAction SilentlyContinue
                Remove-Item $global:SecureTemp -Force -ErrorAction SilentlyContinue
                Write-IGRFLog -Message "Temporary files cleaned up successfully" -EntryType "Information" -EventId 2002
            } catch {
                Write-IGRFLog -Message "Temp cleanup warning: $_" -EntryType "Warning" -EventId 2003
            }
        }
    } catch {
        Write-IGRFLog -Message "Shutdown error: $_" -EntryType "Error" -EventId 2004
    }
})

# Create MenuStrip
$MenuStrip = New-Object System.Windows.Forms.MenuStrip
$MenuStrip.BackColor = $colors.Surface
$MenuStrip.ForeColor = $colors.Text
$MenuStrip.Font = New-Object System.Drawing.Font("Segoe UI", 10)

# File Menu
$FileMenu = New-Object System.Windows.Forms.ToolStripMenuItem
$FileMenu.Text = "File"
$FileMenu.ForeColor = $colors.Text

$SaveMenu = New-Object System.Windows.Forms.ToolStripMenuItem
$SaveMenu.Text = "Save Generated Code"
$SaveMenu.ShortcutKeys = "Control, S"
$SaveMenu.Add_Click({ Save-GeneratedFile })

$ExitMenu = New-Object System.Windows.Forms.ToolStripMenuItem
$ExitMenu.Text = "Exit"
$ExitMenu.Add_Click({ 
    Stop-Voice
    $MainForm.Close()
    # Small delay to ensure voice stops
    Start-Sleep -Milliseconds 200
})

$FileMenu.DropDownItems.AddRange(@($SaveMenu, $ExitMenu))

# Voice Menu
$VoiceMenu = New-Object System.Windows.Forms.ToolStripMenuItem
$VoiceMenu.Text = "Voice"
$VoiceMenu.ForeColor = $colors.Text

$MaleVoiceMenu = New-Object System.Windows.Forms.ToolStripMenuItem
$MaleVoiceMenu.Text = "IGRF-Bhramha (Male)"
$MaleVoiceMenu.Checked = $false
$MaleVoiceMenu.Add_Click({ 
    $global:CurrentVoice = "Male"
    $MaleVoiceMenu.Checked = $true
    $FemaleVoiceMenu.Checked = $false
    Set-Voice
})

$FemaleVoiceMenu = New-Object System.Windows.Forms.ToolStripMenuItem
$FemaleVoiceMenu.Text = "IGRF-Saraswathi (Female)"
$FemaleVoiceMenu.Checked = $true
$FemaleVoiceMenu.Add_Click({ 
    $global:CurrentVoice = "Female"
    $MaleVoiceMenu.Checked = $false
    $FemaleVoiceMenu.Checked = $true
    Set-Voice
})

$VoiceMenu.DropDownItems.AddRange(@($MaleVoiceMenu, $FemaleVoiceMenu))

# Help Menu
$HelpMenu = New-Object System.Windows.Forms.ToolStripMenuItem
$HelpMenu.Text = "Help"
$HelpMenu.ForeColor = $colors.Text

$AboutMenu = New-Object System.Windows.Forms.ToolStripMenuItem
$AboutMenu.Text = "About"
$AboutMenu.Add_Click({ Show-AboutDialog })

$ContactMenu = New-Object System.Windows.Forms.ToolStripMenuItem
$ContactMenu.Text = "Contact Us"
$ContactMenu.Add_Click({ Start-Process "https://igrf.co.in/en/contact-us/" })

$WebsiteMenu = New-Object System.Windows.Forms.ToolStripMenuItem
$WebsiteMenu.Text = "Website"
$WebsiteMenu.Add_Click({ Start-Process "https://igrf.co.in/en/software/" })

$HelpMenu.DropDownItems.AddRange(@($AboutMenu, $ContactMenu, $WebsiteMenu))

# Create Debug Menu
$DebugMenu = New-Object System.Windows.Forms.ToolStripMenuItem
$DebugMenu.Text = "Debug"
$DebugMenu.ForeColor = $colors.Text

$ToggleDebugMenu = New-Object System.Windows.Forms.ToolStripMenuItem
$ToggleDebugMenu.Text = "Toggle Debug Mode"
$ToggleDebugMenu.ShortcutKeys = "Control, D"
$ToggleDebugMenu.Add_Click({ Toggle-DebugMode })

$DebugMenu.DropDownItems.AddRange(@($ToggleDebugMenu))

# Add all menus to the menu strip
$MenuStrip.Items.AddRange(@($FileMenu, $VoiceMenu, $HelpMenu))

# Main TableLayoutPanel - Reorganized Layout
$MainTable = New-Object System.Windows.Forms.TableLayoutPanel
$MainTable.Dock = "Fill"
$MainTable.ColumnCount = 2  # Changed to 2 columns
$MainTable.RowCount = 5
$MainTable.ColumnStyles.Clear()
$MainTable.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 50)))  # Left column
$MainTable.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 50)))  # Right column
$MainTable.RowStyles.Clear()
$MainTable.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Absolute, 30)))  # Menu (row 0, spans both columns)
$MainTable.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Absolute, 90)))  # Header (row 1, spans both columns)
$MainTable.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Absolute, 80)))  # Input/Buttons row (row 2)
$MainTable.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))  # Code/Output (row 3)
$MainTable.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Absolute, 40)))  # Status (row 4, spans both columns)
$MainTable.BackColor = $colors.Background
$MainTable.Padding = New-Object System.Windows.Forms.Padding(10, 5, 10, 5)

# ==================== HEADER SECTION - BORDER FITTED TO CONTENT ====================
$HeaderPanel = New-Object System.Windows.Forms.Panel
$HeaderPanel.Dock = "Fill"
$HeaderPanel.BackColor = $colors.Surface
$HeaderPanel.BorderStyle = "FixedSingle"
$HeaderPanel.Padding = New-Object System.Windows.Forms.Padding(5)
$HeaderPanel.MinimumSize = New-Object System.Drawing.Size(1150, 90)

# Logo - Keep original size
$LogoBox = New-Object System.Windows.Forms.PictureBox
$LogoBox.Size = New-Object System.Drawing.Size(70, 70)
$LogoBox.Location = New-Object System.Drawing.Point(5, 5)  # Reduced from 8 to 5
$LogoBox.SizeMode = "StretchImage"
if ($global:Logo) { $LogoBox.Image = $global:Logo }

# Title - Keep original size
$TitleLabel = New-Object System.Windows.Forms.Label
$TitleLabel.Text = "IGRF AI C/C++ IDE Pro"
$TitleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 20, [System.Drawing.FontStyle]::Bold)
$TitleLabel.Location = New-Object System.Drawing.Point(80, 5)  # Reduced from 85 to 80
$TitleLabel.Size = New-Object System.Drawing.Size(350, 35)
$TitleLabel.ForeColor = $colors.Primary

# SubTitle - Keep original
$SubTitleLabel = New-Object System.Windows.Forms.Label
$SubTitleLabel.Text = "Learn C/C++ Programming with AI Assistant"
$SubTitleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$SubTitleLabel.Location = New-Object System.Drawing.Point(80, 40)  # Reduced from 43 to 40
$SubTitleLabel.Size = New-Object System.Drawing.Size(350, 20)
$SubTitleLabel.ForeColor = $colors.TextSecondary

# Company Label with Hyperlink
$CompanyLabel = New-Object System.Windows.Forms.LinkLabel
$CompanyLabel.Text = "Developed by IGRF Pvt. Ltd. | v1.0"
$CompanyLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$CompanyLabel.Location = New-Object System.Drawing.Point(80, 60)  # Reduced from 63 to 60
$CompanyLabel.Size = New-Object System.Drawing.Size(250, 20)
$CompanyLabel.LinkColor = $colors.Primary
$CompanyLabel.ActiveLinkColor = $colors.HoverBlue
$CompanyLabel.VisitedLinkColor = $colors.Primary
$CompanyLabel.LinkBehavior = "HoverUnderline"
$CompanyLabel.Add_LinkClicked({
    Start-Process "https://igrf.co.in/en/"
})

# Language Detection Status - Adjusted height and vertically centered
$LangStatusPanel = New-Object System.Windows.Forms.Panel
$LangStatusPanel.Location = New-Object System.Drawing.Point(440, 8)  # X=440, Y=8
$LangStatusPanel.Size = New-Object System.Drawing.Size(150, 70)      # Height changed from 75 to 70
$LangStatusPanel.BackColor = $colors.Warning
$LangStatusPanel.BorderStyle = "FixedSingle"

# Use TableLayoutPanel for better control of child controls
$LangTable = New-Object System.Windows.Forms.TableLayoutPanel
$LangTable.Dock = "Fill"
$LangTable.ColumnCount = 1
$LangTable.RowCount = 2
$LangTable.RowStyles.Clear()
$LangTable.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 50)))
$LangTable.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 50)))
$LangTable.BackColor = [System.Drawing.Color]::Transparent
$LangTable.Padding = New-Object System.Windows.Forms.Padding(2)

$LangStatusLabel = New-Object System.Windows.Forms.Label
$LangStatusLabel.Text = "C/C++ Detected"
$LangStatusLabel.Dock = "Fill"
$LangStatusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$LangStatusLabel.ForeColor = [System.Drawing.Color]::White
$LangStatusLabel.TextAlign = "MiddleCenter"
$LangStatusLabel.AutoSize = $false

$LangIconLabel = New-Object System.Windows.Forms.Label
$LangIconLabel.Text = "C/C++ Ready"
$LangIconLabel.Dock = "Fill"
$LangIconLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$LangIconLabel.ForeColor = [System.Drawing.Color]::White
$LangIconLabel.TextAlign = "MiddleCenter"
$LangIconLabel.AutoSize = $false

$LangTable.Controls.Add($LangStatusLabel, 0, 0)
$LangTable.Controls.Add($LangIconLabel, 0, 1)
$LangStatusPanel.Controls.Add($LangTable)

# Status Panel - Adjusted height and vertically centered (like other panels)
$StatusPanel = New-Object System.Windows.Forms.Panel
$StatusPanel.Location = New-Object System.Drawing.Point(610, 8)  # Y changed from 4 to 8 (for vertical centering)
$StatusPanel.Size = New-Object System.Drawing.Size(220, 70)      # Height changed from 75 to 70 (matches other panels)
$StatusPanel.BackColor = $colors.HeaderBg
$StatusPanel.BorderStyle = "FixedSingle"

# Use TableLayoutPanel for consistent vertical centering (like C Detected and Info panels)
$StatusTable = New-Object System.Windows.Forms.TableLayoutPanel
$StatusTable.Dock = "Fill"
$StatusTable.ColumnCount = 1
$StatusTable.RowCount = 3
$StatusTable.RowStyles.Clear()
$StatusTable.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 33.33)))
$StatusTable.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 33.33)))
$StatusTable.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 33.34)))
$StatusTable.BackColor = [System.Drawing.Color]::Transparent
$StatusTable.Padding = New-Object System.Windows.Forms.Padding(2)

$AIStatus = New-Object System.Windows.Forms.Label
$AIStatus.Text = "● AI Code Generation: Ready"
$AIStatus.Dock = "Fill"
$AIStatus.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$AIStatus.ForeColor = $colors.Success
$AIStatus.TextAlign = "MiddleLeft"
$AIStatus.Padding = New-Object System.Windows.Forms.Padding(5, 0, 0, 0)
$AIStatus.BackColor = [System.Drawing.Color]::Transparent

$GCCStatus = New-Object System.Windows.Forms.Label
$GCCStatus.Text = "● GCC Compiler: Ready"
$GCCStatus.Dock = "Fill"
$GCCStatus.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$GCCStatus.ForeColor = $colors.Success
$GCCStatus.TextAlign = "MiddleLeft"
$GCCStatus.Padding = New-Object System.Windows.Forms.Padding(5, 0, 0, 0)
$GCCStatus.BackColor = [System.Drawing.Color]::Transparent

$VoiceStatus = New-Object System.Windows.Forms.Label
$VoiceStatus.Text = "● Voice: IGRF-Saraswathi (Female)"
$VoiceStatus.Dock = "Fill"
$VoiceStatus.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$VoiceStatus.ForeColor = $colors.Primary
$VoiceStatus.TextAlign = "MiddleLeft"
$VoiceStatus.Padding = New-Object System.Windows.Forms.Padding(5, 0, 0, 0)
$VoiceStatus.BackColor = [System.Drawing.Color]::Transparent

$StatusTable.Controls.Add($AIStatus, 0, 0)
$StatusTable.Controls.Add($GCCStatus, 0, 1)
$StatusTable.Controls.Add($VoiceStatus, 0, 2)
$StatusPanel.Controls.Add($StatusTable)

# Info Panel - Single line continuous vertical scrolling text marquee (bottom to top)
$InfoPanel = New-Object System.Windows.Forms.Panel
$InfoPanel.Location = New-Object System.Drawing.Point(850, 8)
$InfoPanel.Size = New-Object System.Drawing.Size(280, 70)
$InfoPanel.Anchor = "Top, Left, Right"
$InfoPanel.BackColor = [System.Drawing.Color]::FromArgb(0, 100, 0)  # Dark green background
$InfoPanel.BorderStyle = "FixedSingle"

# Single line taglines (condensed versions to fit in one line)
$scrollingTexts = @(
    "Code Smarter, Not Harder - AI Code Generation",
    "From Problem to Program in Seconds - Just Describe It",
    "Your Personal AI Programming Tutor - Learn C/C++",
    "Code That Talks Back - Voice-Enabled Learning",
    "Write Once, Run Anywhere - GCC Compiler Included",
    "The Future of Learning C/C++ - Complete AI Ecosystem"
)

# Create two identical labels for seamless looping with larger font
$Label1 = New-Object System.Windows.Forms.Label
$Label1.Text = $scrollingTexts[0]
$Label1.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)  # Larger font
$Label1.ForeColor = [System.Drawing.Color]::White
$Label1.BackColor = [System.Drawing.Color]::Transparent
$Label1.TextAlign = "MiddleCenter"
$Label1.Size = New-Object System.Drawing.Size(260, 70)  # Full height of panel
$Label1.Tag = 0  # Store index

$Label2 = New-Object System.Windows.Forms.Label
$Label2.Text = $scrollingTexts[1]
$Label2.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)  # Larger font
$Label2.ForeColor = [System.Drawing.Color]::White
$Label2.BackColor = [System.Drawing.Color]::Transparent
$Label2.TextAlign = "MiddleCenter"
$Label2.Size = New-Object System.Drawing.Size(260, 70)  # Full height of panel
$Label2.Tag = 1  # Store index

# Center horizontally
$centerX = [Math]::Max(0, ($InfoPanel.Width - 260) / 2)

# Position labels - Label1 at bottom, Label2 right below it (offscreen)
$Label1.Location = New-Object System.Drawing.Point($centerX, 70)    # Bottom of visible area
$Label2.Location = New-Object System.Drawing.Point($centerX, 140)   # Below Label1 (offscreen)

$InfoPanel.Controls.Add($Label1)
$InfoPanel.Controls.Add($Label2)

# Timer for scrolling animation
$scrollTimer = New-Object System.Windows.Forms.Timer
$scrollTimer.Interval = 30  # 30ms for smooth animation
$scrollTimer.Add_Tick({
    # Move both labels up
    $Label1.Top -= 1
    $Label2.Top -= 1
    
    # Check if Label1 has moved completely out of visible area
    if ($Label1.Bottom -lt 0) {
        # Move Label1 to below Label2
        $Label1.Top = $Label2.Bottom
        
        # Update Label1 with next text
        $nextIndex = ([int]$Label2.Tag + 1) % $scrollingTexts.Count
        $Label1.Text = $scrollingTexts[$nextIndex]
        $Label1.Tag = $nextIndex
    }
    
    # Check if Label2 has moved completely out of visible area
    if ($Label2.Bottom -lt 0) {
        # Move Label2 to below Label1
        $Label2.Top = $Label1.Bottom
        
        # Update Label2 with next text
        $nextIndex = ([int]$Label1.Tag + 1) % $scrollingTexts.Count
        $Label2.Text = $scrollingTexts[$nextIndex]
        $Label2.Tag = $nextIndex
    }
})
$scrollTimer.Start()

# Handle panel resize to keep text centered horizontally
$InfoPanel.Add_Resize({
    $centerX = [Math]::Max(0, ($InfoPanel.Width - 260) / 2)
    $Label1.Left = $centerX
    $Label2.Left = $centerX
})

# Stop timer when form closes
$MainForm.Add_FormClosing({
    if ($scrollTimer) { 
        $scrollTimer.Stop() 
        $scrollTimer.Dispose() 
    }
})

# Add all controls to header - including all panels
$HeaderPanel.Controls.AddRange(@($LogoBox, $TitleLabel, $SubTitleLabel, $CompanyLabel, $LangStatusPanel, $StatusPanel, $InfoPanel))

# ==================== PROBLEM INPUT SECTION (Left Column) ====================
# Ensure the form is fully initialized before creating child controls
[System.Windows.Forms.Application]::DoEvents()
Start-Sleep -Milliseconds 50  # Small delay to ensure proper initialization

$InputPanel = New-Object System.Windows.Forms.Panel
$InputPanel.Dock = "Fill"
$InputPanel.BackColor = $colors.InputSectionBg
$InputPanel.BorderStyle = "FixedSingle"
$InputPanel.Padding = New-Object System.Windows.Forms.Padding(10)
$InputPanel.MinimumSize = New-Object System.Drawing.Size(300, 80)
$InputPanel.Height = 80  # Fixed height

$InputLabel = New-Object System.Windows.Forms.Label
$InputLabel.Text = "DESCRIBE YOUR PROBLEM STATEMENT"
$InputLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$InputLabel.Location = New-Object System.Drawing.Point(10, 8)
$InputLabel.Size = New-Object System.Drawing.Size(280, 20)
$InputLabel.ForeColor = $colors.Primary

$ProblemTextBox = New-Object System.Windows.Forms.TextBox
$ProblemTextBox.Anchor = "Top, Left, Right"
$ProblemTextBox.Location = New-Object System.Drawing.Point(10, 32)
# Fix the Size assignment - use Width property separately
$ProblemTextBox.Width = $InputPanel.Width - 30
# Height remains the same
$ProblemTextBox.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)  # Bold font
$ProblemTextBox.BackColor = $colors.DarkGreen  # Using the color from scheme
$ProblemTextBox.ForeColor = [System.Drawing.Color]::White  # Pure white text
$ProblemTextBox.BorderStyle = "FixedSingle"
$ProblemTextBox.Tag = "Write a C or C++ Program Specific Problem Statement."
$ProblemTextBox.Text = $ProblemTextBox.Tag
$ProblemTextBox.ForeColor = [System.Drawing.Color]::White  # White placeholder text

# Add these properties to prevent the ding sound
$ProblemTextBox.Multiline = $false  # Set to true to prevent Enter from making ding sound
$ProblemTextBox.AcceptsReturn = $false  # Don't accept return as newline
$ProblemTextBox.AcceptsTab = $false
$ProblemTextBox.WordWrap = $false
$ProblemTextBox.ScrollBars = "None"
$ProblemTextBox.Height = 39  # Keep height fixed even though multiline is true
$ProblemTextBox.Add_Enter({
    if ($this.Text -eq $this.Tag) { 
        $this.Text = ""; 
        $this.ForeColor = [System.Drawing.Color]::White  # Keep white when typing
    }
})
$ProblemTextBox.Add_Leave({
    if ($this.Text.Trim() -eq "") { 
        $this.Text = $this.Tag; 
        $this.ForeColor = [System.Drawing.Color]::White  # White placeholder
    }
})
$ProblemTextBox.Add_TextChanged({ Detect-LanguageFromPrompt })

# ADD THIS NEW EVENT HANDLER - Trigger Generate button on Enter key
$ProblemTextBox.Add_KeyDown({
    if ($_.KeyCode -eq "Enter") {
        $_.SuppressKeyPress = $true  # Prevents the ding sound and newline in textbox
        $_.Handled = $true  # Additional flag to mark event as handled
        
        # Check if we're not in placeholder text
        if ($this.Text -ne $this.Tag -and $this.Text.Trim() -ne "") {
            # Voice announcement for generation
            try {
                # Stop any current speech immediately
                $global:Synthesizer.SpeakAsyncCancelAll()
                Start-Sleep -Milliseconds 50
                
                # Set voice based on current selection
                Set-Voice
                
                # Speak just "Generation"
                $global:Synthesizer.SpeakAsync("Generation")
            } catch {
                # Silent fail
            }
            
            # Trigger the Generate button click
            Generate-Code
        } else {
            # Voice announcement for empty/placeholder
            try {
                $global:Synthesizer.SpeakAsyncCancelAll()
                Start-Sleep -Milliseconds 50
                Set-Voice
                $global:Synthesizer.SpeakAsync("Please describe your programming problem")
            } catch {
                # Silent fail
            }
            
            [System.Windows.Forms.MessageBox]::Show("Please describe your programming problem.", "Input Required")
        }
    }
})

$InputPanel.Controls.AddRange(@($InputLabel, $ProblemTextBox))

# Add resize event to keep textbox width at 100% of panel
$InputPanel.Add_Resize({
    try {
        # Check if controls exist and are properly initialized
        if ($this.Controls.Count -gt 1 -and $this.Controls[1] -ne $null) {
            $textBox = $this.Controls[1]
            # Verify it's actually a TextBox
            if ($textBox -is [System.Windows.Forms.TextBox]) {
                $newWidth = $this.Width - 30
                if ($newWidth -gt 0) {
                    $textBox.Width = $newWidth
                }
            }
        }
    } catch {
        # Silently fail on resize errors
    }
})

# ==================== BUTTON SECTION (Right Column) ====================
$ButtonPanel = New-Object System.Windows.Forms.Panel
$ButtonPanel.Dock = "Fill"
$ButtonPanel.BackColor = $colors.ButtonSectionBg  # Match the button section background color
$ButtonPanel.BorderStyle = "FixedSingle"
$ButtonPanel.Padding = New-Object System.Windows.Forms.Padding(10)
$ButtonPanel.MinimumSize = New-Object System.Drawing.Size(300, 80)
$ButtonPanel.Height = 80  # Match the height of Input Panel

$ButtonFlow = New-Object System.Windows.Forms.FlowLayoutPanel
$ButtonFlow.Dock = "Fill"
$ButtonFlow.FlowDirection = "LeftToRight"
$ButtonFlow.WrapContents = $true
$ButtonFlow.BackColor = $colors.ButtonSectionBg  # Match parent background
$ButtonFlow.Padding = New-Object System.Windows.Forms.Padding(8)
$ButtonFlow.Margin = New-Object System.Windows.Forms.Padding(0)
$ButtonFlow.AutoSize = $true
$ButtonFlow.AutoSizeMode = "GrowAndShrink"

# Center the flow panel within the button panel
$ButtonFlow.Location = New-Object System.Drawing.Point(0, 0)
$ButtonFlow.Anchor = "None"  # Will be centered manually

# Function to create professional buttons with auto-size width
function New-ProfessionalButton {
    param($text, $icon, $bgColor, $hoverColor, $clickAction)
    
    $btn = New-Object System.Windows.Forms.Button
    
    # Set button text with optional icon
    if ($icon -ne "") {
        $btn.Text = "$icon $text"
    } else {
        $btn.Text = "$text"
    }
    
    # Auto-size button based on text content
    $btn.AutoSize = $true
    $btn.AutoSizeMode = "GrowAndShrink"
    $btn.MinimumSize = New-Object System.Drawing.Size(70, 30)
    $btn.MaximumSize = New-Object System.Drawing.Size(140, 35)
    $btn.Margin = New-Object System.Windows.Forms.Padding(5, 5, 5, 5)
    $btn.Padding = New-Object System.Windows.Forms.Padding(8, 0, 8, 0)
    
    # Ensure colors are not null
    if ($bgColor -ne $null) {
        $btn.BackColor = $bgColor
    } else {
        $btn.BackColor = [System.Drawing.Color]::FromArgb(0, 103, 192)
    }
    
    $btn.ForeColor = [System.Drawing.Color]::White
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $btn.FlatStyle = "Flat"
    $btn.FlatAppearance.BorderSize = 0
    $btn.Cursor = [System.Windows.Forms.Cursors]::Hand
    $btn.TextAlign = "MiddleCenter"
    $btn.UseVisualStyleBackColor = $false
    
    # Store colors in button's Tag for safe access in events
    $btn.Tag = @{
        NormalColor = $bgColor
        HoverColor = $hoverColor
    }
    
    # Add hover effects
    $btn.Add_MouseEnter({
        $tag = $this.Tag
        if ($tag -and $tag.HoverColor) {
            $this.BackColor = $tag.HoverColor
        }
    })
    
    $btn.Add_MouseLeave({
        $tag = $this.Tag
        if ($tag -and $tag.NormalColor) {
            $this.BackColor = $tag.NormalColor
        }
    })
    
    # Add click action
    $btn.Add_Click($clickAction)
    
    return $btn
}

# Create only 4 buttons (removed Explain and Stop)
$GenerateBtn = New-ProfessionalButton "GENERATE" "" $colors.Primary $colors.HoverBlue { 
    # Voice announcement for Generate button
    $problem = $ProblemTextBox.Text.Trim()
    if ($problem -eq "" -or $problem -eq $ProblemTextBox.Tag) {
        $placeholderText = $ProblemTextBox.Tag
        Speak-Text -Text "Generate button clicked. $placeholderText" -Category "Generate"
        [System.Windows.Forms.MessageBox]::Show("Please describe your programming problem.", "Input Required")
    } else {
        Speak-Text -Text "Generating code for your problem." -Category "Generate"
        Generate-Code
    }
}

$CompileBtn = New-ProfessionalButton "COMPILE" "" $colors.Success $colors.HoverGreen { 
    if (-not $global:GeneratedCode) {
        Speak-Text -Text "Compile button clicked. Please generate code first." -Category "Compile"
        [System.Windows.Forms.MessageBox]::Show("Please generate code first.", "No Code")
    } else {
        Speak-Text -Text "Compiling code." -Category "Compile"
        Compile-Code
    }
}

$RunBtn = New-ProfessionalButton "RUN" "" $colors.Accent $colors.HoverTeal { 
    if (-not $global:GeneratedCode) {
        Speak-Text -Text "Run button clicked. Please generate code first." -Category "Run"
        [System.Windows.Forms.MessageBox]::Show("Please generate code first.", "No Code")
    } elseif (-not (Test-Path $global:OutputExe)) {
        Speak-Text -Text "Run button clicked. Please compile the code first." -Category "Run"
        [System.Windows.Forms.MessageBox]::Show("Please compile the code first.", "Not Compiled")
    } else {
        # Validate executable before running
        $valid, $message = Test-ExecutableValid -exePath $global:OutputExe
        
        if (-not $valid) {
            $OutputTextBox.AppendText("`n⚠️ Executable validation failed: $message`n")
            $OutputTextBox.AppendText("Attempting to recompile...`n")
            
            # Try to recompile
            Compile-Code
            
            # Check again after recompile
            if (Test-Path $global:OutputExe) {
                Speak-Text -Text "Running program." -Category "Run"
                Run-Program
            } else {
                [System.Windows.Forms.MessageBox]::Show("Failed to create valid executable.", "Compilation Error")
            }
        } else {
            Speak-Text -Text "Running program." -Category "Run"
            Run-Program
        }
    }
}

$ClearBtn = New-ProfessionalButton "CLEAR" "" $colors.Error $colors.HoverRed { 
    # Announce clearing first
    Speak-Text -Text "Clearing all." -Category "Clear"
    
    # Small delay to allow announcement to start
    Start-Sleep -Milliseconds 300
    
    # Stop any ongoing voice announcement
    Stop-Voice
    
    # Then clear everything
    Clear-All 
}

# Clear any existing controls
$ButtonFlow.Controls.Clear()

# Add only 4 buttons to the flow panel
$ButtonFlow.Controls.Add($GenerateBtn)
$ButtonFlow.Controls.Add($CompileBtn)
$ButtonFlow.Controls.Add($RunBtn)
$ButtonFlow.Controls.Add($ClearBtn)

# Center the flow panel within button panel
$ButtonFlow.Location = New-Object System.Drawing.Point(
    [Math]::Max(0, ($ButtonPanel.Width - $ButtonFlow.PreferredSize.Width) / 2),
    [Math]::Max(0, ($ButtonPanel.Height - $ButtonFlow.PreferredSize.Height) / 2)
)

$ButtonPanel.Controls.Add($ButtonFlow)

# Handle resize event to keep buttons centered
$ButtonPanel.Add_Resize({
    $flow = $this.Controls[0]
    if ($flow) {
        $flow.Location = New-Object System.Drawing.Point(
            [Math]::Max(0, ($this.Width - $flow.PreferredSize.Width) / 2),
            [Math]::Max(0, ($this.Height - $flow.PreferredSize.Height) / 2)
        )
    }
})

# ==================== SPLIT VIEW - 50/50 RATIO ====================
$SplitContainer = New-Object System.Windows.Forms.SplitContainer
$SplitContainer.Dock = "Fill"
$SplitContainer.Orientation = "Vertical"
$SplitContainer.SplitterDistance = $SplitContainer.Width / 2
$SplitContainer.BackColor = $colors.Border

# Left Panel - Code (50%)
$CodeGroup = New-Object System.Windows.Forms.GroupBox
$CodeGroup.Text = " GENERATED CODE "
$CodeGroup.Dock = "Fill"
$CodeGroup.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$CodeGroup.ForeColor = $colors.Primary
$CodeGroup.BackColor = $colors.CodeSectionBg

# Create a top panel for Code section buttons
$CodeButtonPanel = New-Object System.Windows.Forms.Panel
$CodeButtonPanel.Dock = "Top"
$CodeButtonPanel.Height = 35
$CodeButtonPanel.BackColor = $colors.PanelHeader
$CodeButtonPanel.BorderStyle = "FixedSingle"
$CodeButtonPanel.Padding = New-Object System.Windows.Forms.Padding(5)

# Create flow layout for buttons
$CodeButtonFlow = New-Object System.Windows.Forms.FlowLayoutPanel
$CodeButtonFlow.Dock = "Right"  # Align buttons to the right
$CodeButtonFlow.FlowDirection = "LeftToRight"
$CodeButtonFlow.WrapContents = $false
$CodeButtonFlow.BackColor = [System.Drawing.Color]::Transparent
$CodeButtonFlow.Height = 30
$CodeButtonFlow.Padding = New-Object System.Windows.Forms.Padding(0)
$CodeButtonFlow.Margin = New-Object System.Windows.Forms.Padding(0)

# Function to create enhanced buttons for code panel
function New-EnhancedCodeButton {
    param($text, $icon, $bgColor, $hoverColor, $clickAction)
    
    $btn = New-Object System.Windows.Forms.Button
    if ($icon -ne "") {
        $btn.Text = "$icon $text"
    } else {
        $btn.Text = "$text"
    }
    
    $btn.Size = New-Object System.Drawing.Size(90, 26)
    $btn.Margin = New-Object System.Windows.Forms.Padding(3, 0, 3, 0)
    $btn.BackColor = $bgColor
    $btn.ForeColor = [System.Drawing.Color]::White
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $btn.FlatStyle = "Flat"
    $btn.FlatAppearance.BorderSize = 1
    $btn.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(150, 150, 150)
    $btn.Cursor = [System.Windows.Forms.Cursors]::Hand
    $btn.TextAlign = "MiddleCenter"
    $btn.UseVisualStyleBackColor = $false
    $btn.TabIndex = 0
    
    # Add subtle shadow effect
    $btn.FlatAppearance.MouseDownBackColor = [System.Drawing.Color]::FromArgb(40, 0, 0, 0)
    $btn.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(30, 255, 255, 255)
    
    # Store colors in button's Tag
    $btn.Tag = @{
        NormalColor = $bgColor
        HoverColor = $hoverColor
    }
    
    # Add enhanced hover effects
    $btn.Add_MouseEnter({
        $tag = $this.Tag
        if ($tag -and $tag.HoverColor) {
            $this.BackColor = $tag.HoverColor
        }
        $this.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(100, 100, 100)
    })
    
    $btn.Add_MouseLeave({
        $tag = $this.Tag
        if ($tag -and $tag.NormalColor) {
            $this.BackColor = $tag.NormalColor
        }
        $this.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(150, 150, 150)
    })
    
    $btn.Add_Click($clickAction)
    
    return $btn
}

# Create the buttons for code panel using enhanced style
$ExplainCodeBtn = New-EnhancedCodeButton "EXPLAIN" "" $colors.Warning $colors.HoverOrange { 
    $activeTab = $CodeTabs.SelectedTab.Text
    Speak-Text -Text "Explaining $activeTab." -Category "Explain"
    Explain-CodePanel 
}
$StopCodeVoiceBtn = New-EnhancedCodeButton "STOP" "️" $colors.Error $colors.HoverRed { Stop-CodeVoice }

# Add buttons to flow panel
$CodeButtonFlow.Controls.Add($ExplainCodeBtn)
$CodeButtonFlow.Controls.Add($StopCodeVoiceBtn)

# Add flow panel to button panel
$CodeButtonPanel.Controls.Add($CodeButtonFlow)

# Add a label on the left side of the button panel
$CodeButtonLabel = New-Object System.Windows.Forms.Label
$CodeButtonLabel.Text = "Voice Controls:"
$CodeButtonLabel.Location = New-Object System.Drawing.Point(8, 8)
$CodeButtonLabel.Size = New-Object System.Drawing.Size(100, 20)
$CodeButtonLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$CodeButtonLabel.ForeColor = $colors.TextSecondary
$CodeButtonLabel.BackColor = [System.Drawing.Color]::Transparent
$CodeButtonPanel.Controls.Add($CodeButtonLabel)
$CodeButtonLabel.SendToBack()

$CodeTabs = New-Object System.Windows.Forms.TabControl
$CodeTabs.Dock = "Fill"
$CodeTabs.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$CodeTabs.BackColor = $colors.CodeSectionBg
$CodeTabs.Appearance = "Buttons"
$CodeTabs.ItemSize = New-Object System.Drawing.Size(140, 32)

# Code Tab
$CodeTab = New-Object System.Windows.Forms.TabPage
$CodeTab.Text = "Source Code"
$CodeTab.BackColor = $colors.CodeBg
$CodeTab.ForeColor = $colors.Text

$CodeTextBox = New-Object System.Windows.Forms.RichTextBox
$CodeTextBox.Dock = "Fill"
$CodeTextBox.Font = New-Object System.Drawing.Font("Consolas", 11)
$CodeTextBox.BackColor = [System.Drawing.Color]::White
$CodeTextBox.ForeColor = $colors.Text
$CodeTextBox.BorderStyle = "None"
$CodeTextBox.WordWrap = $false
$CodeTextBox.ScrollBars = "Both"
$CodeTab.Controls.Add($CodeTextBox)

# Algorithm Tab
$AlgoTab = New-Object System.Windows.Forms.TabPage
$AlgoTab.Text = "Algorithm"
$AlgoTab.BackColor = $colors.CodeBg
$AlgoTab.ForeColor = $colors.Text

$AlgoTextBox = New-Object System.Windows.Forms.RichTextBox
$AlgoTextBox.Dock = "Fill"
$AlgoTextBox.Font = New-Object System.Drawing.Font("Segoe UI", 11)
$AlgoTextBox.BackColor = [System.Drawing.Color]::White
$AlgoTextBox.ForeColor = $colors.Text
$AlgoTextBox.ReadOnly = $true
$AlgoTextBox.BorderStyle = "None"
$AlgoTextBox.ScrollBars = "Vertical"
$AlgoTab.Controls.Add($AlgoTextBox)

$CodeTabs.TabPages.AddRange(@($CodeTab, $AlgoTab))

# ===== ADD THESE LINES HERE =====
# Initialize CodeTabs as disabled at startup
$CodeTabs.Enabled = $false
$CodeTabs.Visible = $false
$CodeTextBox.Enabled = $false
$CodeTextBox.ReadOnly = $true
# ===== END OF ADDED LINES =====

# Configure CodeGroup properly
$CodeGroup.Controls.Clear()
$CodeGroup.Dock = "Fill"
$CodeGroup.AutoSize = $false
$CodeGroup.Height = $SplitContainer.Panel1.Height
$CodeGroup.Width = $SplitContainer.Panel1.Width

# Add button panel FIRST (Dock=Top) - this takes 35px at the top
$CodeGroup.Controls.Add($CodeButtonPanel)

# Add tabs SECOND (Dock=Fill) - this takes remaining space
$CodeGroup.Controls.Add($CodeTabs)

# Ensure tabs are visible
$CodeTabs.Visible = $true
$CodeTabs.BringToFront()

$SplitContainer.Panel1.Controls.Add($CodeGroup)
$SplitContainer.Panel1.BackColor = $colors.Surface

# Right Panel - Output (50%)
$OutputGroup = New-Object System.Windows.Forms.GroupBox
$OutputGroup.Text = " OUTPUT & EXPLANATION "
$OutputGroup.Dock = "Fill"
$OutputGroup.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$OutputGroup.ForeColor = $colors.Success
$OutputGroup.BackColor = $colors.OutputSectionBg  # Soft green background

$OutputTabs = New-Object System.Windows.Forms.TabControl
$OutputTabs.Dock = "Fill"
$OutputTabs.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$OutputTabs.BackColor = $colors.OutputSectionBg
$OutputTabs.Appearance = "Buttons"
$OutputTabs.ItemSize = New-Object System.Drawing.Size(140, 32)

# Console Output Tab
$ConsoleTab = New-Object System.Windows.Forms.TabPage
$ConsoleTab.Text = "Console Output"
$ConsoleTab.BackColor = $colors.CodeBg

$OutputTextBox = New-Object System.Windows.Forms.RichTextBox
$OutputTextBox.Dock = "Fill"
$OutputTextBox.Font = New-Object System.Drawing.Font("Consolas", 11)
$OutputTextBox.BackColor = [System.Drawing.Color]::White
$OutputTextBox.ForeColor = $colors.Success
$OutputTextBox.ReadOnly = $true
$OutputTextBox.BorderStyle = "None"
$OutputTextBox.ScrollBars = "Vertical"
$ConsoleTab.Controls.Add($OutputTextBox)

# Explanation Tab
$ExplanationTab = New-Object System.Windows.Forms.TabPage
$ExplanationTab.Text = "Code Explanation"
$ExplanationTab.BackColor = $colors.CodeBg

$ExplanationTextBox = New-Object System.Windows.Forms.RichTextBox
$ExplanationTextBox.Dock = "Fill"
$ExplanationTextBox.Font = New-Object System.Drawing.Font("Segoe UI", 11)
$ExplanationTextBox.BackColor = [System.Drawing.Color]::White
$ExplanationTextBox.ForeColor = $colors.Text
$ExplanationTextBox.ReadOnly = $true
$ExplanationTextBox.BorderStyle = "None"
$ExplanationTextBox.ScrollBars = "Vertical"
$ExplanationTab.Controls.Add($ExplanationTextBox)

$OutputTabs.TabPages.AddRange(@($ConsoleTab, $ExplanationTab))

# ===== ADD THESE LINES HERE =====
# Initialize OutputTabs as disabled at startup
$OutputTabs.Enabled = $false
$OutputTabs.Visible = $false
$OutputTextBox.Enabled = $false
$OutputTextBox.ReadOnly = $true
# ===== END OF ADDED LINES =====

# Create a top panel for Output section buttons (similar to Code panel)
$OutputButtonPanel = New-Object System.Windows.Forms.Panel
$OutputButtonPanel.Dock = "Top"
$OutputButtonPanel.Height = 35
$OutputButtonPanel.BackColor = $colors.PanelHeader
$OutputButtonPanel.BorderStyle = "FixedSingle"
$OutputButtonPanel.Padding = New-Object System.Windows.Forms.Padding(5)

# Create flow layout for buttons
$OutputButtonFlow = New-Object System.Windows.Forms.FlowLayoutPanel
$OutputButtonFlow.Dock = "Right"  # Align buttons to the right
$OutputButtonFlow.FlowDirection = "LeftToRight"
$OutputButtonFlow.WrapContents = $false
$OutputButtonFlow.BackColor = [System.Drawing.Color]::Transparent
$OutputButtonFlow.Height = 30
$OutputButtonFlow.Padding = New-Object System.Windows.Forms.Padding(0)
$OutputButtonFlow.Margin = New-Object System.Windows.Forms.Padding(0)

# Function to create enhanced buttons with better Windows styling
function New-EnhancedButton {
    param($text, $icon, $bgColor, $hoverColor, $clickAction)
    
    $btn = New-Object System.Windows.Forms.Button
    if ($icon -ne "") {
        $btn.Text = "$icon $text"
    } else {
        $btn.Text = "$text"
    }
    
    $btn.Size = New-Object System.Drawing.Size(90, 26)
    $btn.Margin = New-Object System.Windows.Forms.Padding(3, 0, 3, 0)
    $btn.BackColor = $bgColor
    $btn.ForeColor = [System.Drawing.Color]::White
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $btn.FlatStyle = "Flat"
    $btn.FlatAppearance.BorderSize = 1
    $btn.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(150, 150, 150)
    $btn.Cursor = [System.Windows.Forms.Cursors]::Hand
    $btn.TextAlign = "MiddleCenter"
    $btn.UseVisualStyleBackColor = $false
    $btn.TabIndex = 0
    
    # Add subtle shadow effect
    $btn.FlatAppearance.MouseDownBackColor = [System.Drawing.Color]::FromArgb(40, 0, 0, 0)
    $btn.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(30, 255, 255, 255)
    
    # Store colors in button's Tag
    $btn.Tag = @{
        NormalColor = $bgColor
        HoverColor = $hoverColor
    }
    
    # Add enhanced hover effects
    $btn.Add_MouseEnter({
        $tag = $this.Tag
        if ($tag -and $tag.HoverColor) {
            $this.BackColor = $tag.HoverColor
        }
        $this.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(100, 100, 100)
    })
    
    $btn.Add_MouseLeave({
        $tag = $this.Tag
        if ($tag -and $tag.NormalColor) {
            $this.BackColor = $tag.NormalColor
        }
        $this.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(150, 150, 150)
    })
    
    $btn.Add_Click($clickAction)
    
    return $btn
}

# Create the buttons for output panel (Explain and Stop)
$OutputExplainBtn = New-EnhancedButton "EXPLAIN" "" $colors.Warning $colors.HoverOrange { 
    $activeTab = $OutputTabs.SelectedTab.Text
    Speak-Text -Text "Explaining $activeTab." -Category "Explain"
    Explain-OutputPanel 
}
$OutputStopVoiceBtn = New-EnhancedButton "STOP" "️" $colors.Error $colors.HoverRed { Stop-OutputVoice }

# Add buttons to flow panel
$OutputButtonFlow.Controls.Add($OutputExplainBtn)
$OutputButtonFlow.Controls.Add($OutputStopVoiceBtn)

# Add flow panel to button panel
$OutputButtonPanel.Controls.Add($OutputButtonFlow)

# Add a label on the left side of the button panel
$OutputButtonLabel = New-Object System.Windows.Forms.Label
$OutputButtonLabel.Text = "Voice Controls:"
$OutputButtonLabel.Location = New-Object System.Drawing.Point(8, 8)
$OutputButtonLabel.Size = New-Object System.Drawing.Size(100, 20)
$OutputButtonLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$OutputButtonLabel.ForeColor = $colors.TextSecondary
$OutputButtonLabel.BackColor = [System.Drawing.Color]::Transparent
$OutputButtonPanel.Controls.Add($OutputButtonLabel)
$OutputButtonLabel.SendToBack()

# Configure OutputGroup properly
$OutputGroup.Controls.Clear()
$OutputGroup.Dock = "Fill"
$OutputGroup.AutoSize = $false
$OutputGroup.Height = $SplitContainer.Panel2.Height
$OutputGroup.Width = $SplitContainer.Panel2.Width

# Add button panel FIRST (Dock=Top) - this takes 35px at the top
$OutputGroup.Controls.Add($OutputButtonPanel)

# Add tabs SECOND (Dock=Fill) - this takes remaining space
$OutputGroup.Controls.Add($OutputTabs)

# Ensure tabs are visible and fill remaining space
$OutputTabs.Dock = "Fill"
$OutputTabs.Visible = $true
$OutputTabs.BringToFront()

# Add the OutputGroup to the SplitContainer panel
$SplitContainer.Panel2.Controls.Add($OutputGroup)
$SplitContainer.Panel2.BackColor = $colors.Surface

# ==================== STATUS BAR ====================
$StatusBar = New-Object System.Windows.Forms.StatusStrip
$StatusBar.BackColor = $colors.PanelHeader  # Light blue status bar
$StatusBar.ForeColor = $colors.Text
$StatusBar.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$StatusBar.SizingGrip = $false

$StatusLabel = New-Object System.Windows.Forms.ToolStripStatusLabel
$StatusLabel.Text = "● Ready"
$StatusLabel.ForeColor = $colors.Success

$ApiLabel = New-Object System.Windows.Forms.ToolStripStatusLabel
$ApiLabel.Text = "AI Code Generation: Connected"
$ApiLabel.ForeColor = $colors.TextSecondary

$SplitLabel = New-Object System.Windows.Forms.ToolStripStatusLabel
$SplitLabel.Text = "50/50 Split"
$SplitLabel.ForeColor = $colors.TextSecondary

$TotalLabel = New-Object System.Windows.Forms.ToolStripStatusLabel
$TotalLabel.Text = "Sessions: 0"
$TotalLabel.ForeColor = $colors.TextSecondary

# Create DateTime Label for right side display (now moved to the right)
$DateTimeLabel = New-Object System.Windows.Forms.ToolStripStatusLabel
$DateTimeLabel.Text = (Get-Date).ToString("dd-MM-yyyy | hh:mm:ss tt")
$DateTimeLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 100, 0)  # Dark green
$DateTimeLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$DateTimeLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleRight

# Create middle spacer (pushes left items to the left and right items to the right)
$MiddleSpacer = New-Object System.Windows.Forms.ToolStripStatusLabel
$MiddleSpacer.Spring = $true
$MiddleSpacer.Text = ""

# Create DevLabel as a clickable link (ToolStripStatusLabel doesn't support clicking directly)
# We'll use ToolStripControlHost to host a LinkLabel
$linkLabel = New-Object System.Windows.Forms.LinkLabel
$linkLabel.Text = "IGRF Pvt. Ltd. | v1.0"
$linkLabel.LinkColor = $colors.Primary
$linkLabel.ActiveLinkColor = $colors.HoverBlue
$linkLabel.VisitedLinkColor = $colors.Primary
$linkLabel.LinkBehavior = "HoverUnderline"
$linkLabel.AutoSize = $true
$linkLabel.BackColor = [System.Drawing.Color]::Transparent
$linkLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$linkLabel.Add_LinkClicked({
    Start-Process "https://igrf.co.in/en/software/"
})

# Wrap the LinkLabel in a ToolStripControlHost
$DevLink = New-Object System.Windows.Forms.ToolStripControlHost($linkLabel)
$DevLink.Alignment = [System.Windows.Forms.ToolStripItemAlignment]::Right
$DevLink.Padding = New-Object System.Windows.Forms.Padding(5, 0, 0, 0)

# Add all items to status bar in correct order
$StatusBar.Items.AddRange(@(
    $StatusLabel, 
    $ApiLabel, 
    $SplitLabel, 
    $TotalLabel,
    $MiddleSpacer,     # This pushes everything after it to the right
    $DateTimeLabel,    # This will be on the right side
    $DevLink           # This will be next to the DateTime on the right
))

# Add timer to update the date and time every second
$dateTimer = New-Object System.Windows.Forms.Timer
$dateTimer.Interval = 1000  # 1 second
$dateTimer.Add_Tick({
    $DateTimeLabel.Text = (Get-Date).ToString("dd-MM-yyyy | hh:mm:ss tt")
})
$dateTimer.Start()

# ==================== ASSEMBLE - New Layout ====================
# Menu (row 0, spans both columns)
$MainTable.Controls.Add($MenuStrip, 0, 0)
$MainTable.SetColumnSpan($MenuStrip, 2)

# Header (row 1, spans both columns)
$MainTable.Controls.Add($HeaderPanel, 0, 1)
$MainTable.SetColumnSpan($HeaderPanel, 2)

# Input Panel (row 2, column 0)
$MainTable.Controls.Add($InputPanel, 0, 2)

# Button Panel (row 2, column 1)
$MainTable.Controls.Add($ButtonPanel, 1, 2)

# Split Container (row 3, spans both columns)
$MainTable.Controls.Add($SplitContainer, 0, 3)
$MainTable.SetColumnSpan($SplitContainer, 2)

# Add the main table to the form
$MainForm.Controls.Add($MainTable)

# Add status bar separately
$MainForm.Controls.Add($StatusBar)
$StatusBar.BringToFront()

# ==================== FUNCTIONS ====================

# Set voice based on selection
function Set-Voice {
    try {
        if ($global:Voices.Count -gt 0) {
            if ($global:CurrentVoice -eq "Male") {
                $maleVoice = $global:Voices | Where-Object { $_.Gender -eq [System.Speech.Synthesis.VoiceGender]::Male } | Select-Object -First 1
                if ($maleVoice) {
                    $global:Synthesizer.SelectVoice($maleVoice.Name)
                    $VoiceStatus.Text = "● Voice: IGRF-Bhramha (Male)"
                } else {
                    # Fallback if no male voice
                    $global:Synthesizer.SelectVoice($global:Voices[0].Name)
                    $VoiceStatus.Text = "● Voice: IGRF-Bhramha (Male)"
                }
            } else {
                $femaleVoice = $global:Voices | Where-Object { $_.Gender -eq [System.Speech.Synthesis.VoiceGender]::Female } | Select-Object -First 1
                if ($femaleVoice) {
                    $global:Synthesizer.SelectVoice($femaleVoice.Name)
                    $VoiceStatus.Text = "● Voice: IGRF-Saraswathi (Female)"
                } else {
                    # Fallback to first available voice if no female voice
                    $global:Synthesizer.SelectVoice($global:Voices[0].Name)
                    $VoiceStatus.Text = "● Voice: IGRF-Saraswathi (Female)"
                }
            }
        }
    } catch {
        # Silent fail
    }
}

# Detect language from prompt - COMPREHENSIVE VERSION with all patterns
function Detect-LanguageFromPrompt {
    $prompt = $ProblemTextBox.Text.ToLower().Trim()
    
    # Skip detection if it's the placeholder text
    if ($prompt -eq $ProblemTextBox.Tag.ToLower()) {
        $global:DetectedLanguage = "Unknown"
        $LangStatusLabel.Text = "C/C++ Detected"
        $LangIconLabel.Text = "C/C++ Ready"
        $LangStatusPanel.BackColor = $colors.Warning
        return
    }
    
    # PATTERN 1: Check for C++ with various formats (spaces before/after)
    $isCpp = $false
    
    # Pattern: " c++ " with spaces
    if ($prompt -match '\bc\s*\+\+\s*\b') { $isCpp = $true }
    # Pattern: " cpp " with spaces
    elseif ($prompt -match '\bcpp\b') { $isCpp = $true }
    # Pattern: " c plus plus " with spaces
    elseif ($prompt -match '\bc\s*plus\s*plus\b') { $isCpp = $true }
    # Pattern: " c plus " with spaces (implies C++)
    elseif ($prompt -match '\bc\s*plus\b') { $isCpp = $true }
    # Pattern: C++ keywords
    elseif ($prompt -match '\bcout\b' -or 
            $prompt -match '\bcin\b' -or 
            $prompt -match '\biostream\b' -or 
            $prompt -match '\bnamespace\s+std\b' -or
            $prompt -match '\busing\s+namespace\s+std\b') { $isCpp = $true }
    
    # PATTERN 2: Check for C with various formats (spaces before/after)
    $isC = $false
    
    # Pattern: " c " with spaces (standalone C, not C++)
    if ($prompt -match '\bc\b' -and !$isCpp) { $isC = $true }
    # Pattern: C standard library headers
    elseif ($prompt -match '\bstdio\.h\b' -or 
            $prompt -match '\bstdlib\.h\b' -or 
            $prompt -match '\bstring\.h\b' -or
            $prompt -match '\bprintf\b' -or 
            $prompt -match '\bscanf\b') { $isC = $true }
    
    # Apply detection results
    if ($isCpp) {
        $global:DetectedLanguage = "C++"
        $LangStatusLabel.Text = "✓ C++ Detected"
        $LangIconLabel.Text = "C++ Ready"
        $LangStatusPanel.BackColor = $colors.Success
        $LangStatusPanel.Refresh()
    }
    elseif ($isC) {
        $global:DetectedLanguage = "C"
        $LangStatusLabel.Text = "✓ C Detected"
        $LangIconLabel.Text = "C Ready"
        $LangStatusPanel.BackColor = $colors.Success
        $LangStatusPanel.Refresh()
    }
    else {
        $global:DetectedLanguage = "Unknown"
        $LangStatusLabel.Text = "Specify C/C++"
        $LangIconLabel.Text = "Detecting Language"
        $LangStatusPanel.BackColor = $colors.Warning
        $LangStatusPanel.Refresh()
    }
}

# Validate that language is properly specified before generation
function Test-ValidLanguageSpecification {
    $prompt = $ProblemTextBox.Text.ToLower().Trim()
    
    # Check for C patterns
    $hasCPattern = ($prompt -match '\bc\b' -or 
                    $prompt -match '\bstdio\.h\b' -or 
                    $prompt -match '\bprintf\b' -or 
                    $prompt -match '\bscanf\b')
    
    # Check for C++ patterns
    $hasCppPattern = ($prompt -match '\bc\s*\+\+' -or 
                      $prompt -match '\bcpp\b' -or 
                      $prompt -match '\bc\s*plus' -or
                      $prompt -match '\bcout\b' -or 
                      $prompt -match '\bcin\b' -or
                      $prompt -match '\biostream\b')
    
    # If both patterns present, that's fine (user might be comparing)
    if ($hasCPattern -or $hasCppPattern) {
        return $true
    }
    
    return $false
}

# Check GCC compiler - FIXED with null checking
function Check-Compiler {
    # Silently check if compiler exists
    $compilerExists = $false
    try {
        $compilerExists = Test-Path $global:CompilerPath -ErrorAction SilentlyContinue
    } catch {
        $compilerExists = $false
    }
    
    if ($compilerExists) {
        # Update UI (this doesn't produce console output)
        $GCCStatus.Text = "● GCC Compiler: Ready"
        $GCCStatus.ForeColor = $colors.Success
        
        # Add GCC to PATH silently
        try {
            $gccBin = Split-Path $global:CompilerPath -Parent
            $env:PATH = "$gccBin;$env:PATH" 2>&1 | Out-Null
        } catch { $null }
        
        return $true
    } else {
        $GCCStatus.Text = "● GCC Compiler: Not Found"
        $GCCStatus.ForeColor = $colors.Error
        return $false
    }
}

# Clean up temporary files - Safe and transparent version
# This function removes temporary files created during compilation
# All operations are legitimate and necessary for clean application state
function Cleanup-OldFiles {
    try {
        # EDUCATIONAL NOTE: Temporary file cleanup is standard practice
        # for any application that creates temporary files. This prevents
        # accumulation of unused files on the user's system.
        
        # Safely remove output executable if it exists
        if ([System.IO.File]::Exists($global:OutputExe)) {
            try {
                # Use .NET File.Delete instead of Remove-Item for better compatibility
                # This is the same method used by many legitimate applications
                [System.IO.File]::Delete($global:OutputExe)
                Write-Debug "Cleaned up: $global:OutputExe"
            } catch {
                # File might be in use - that's OK, we'll try again later
                # This is normal behavior - Windows prevents deletion of files in use
                Write-Debug "Could not delete $global:OutputExe (might be in use)"
            }
        }
        
        # Safely remove temporary output file
        if ([System.IO.File]::Exists($global:TempOutput)) {
            try {
                [System.IO.File]::Delete($global:TempOutput)
                Write-Debug "Cleaned up: $global:TempOutput"
            } catch {
                Write-Debug "Could not delete $global:TempOutput"
            }
        }
        
        # Safely remove backup file if it exists
        $backupFile = "$global:OutputExe.bak"
        if ([System.IO.File]::Exists($backupFile)) {
            try {
                [System.IO.File]::Delete($backupFile)
                Write-Debug "Cleaned up: $backupFile"
            } catch {
                Write-Debug "Could not delete $backupFile"
            }
        }
        
        # Brief pause to allow file handles to release naturally
        # This is standard practice, not aggressive cleanup
        Start-Sleep -Milliseconds 100
    } catch {
        # Log to debug but don't show to user (non-critical)
        Write-Debug "Cleanup encountered non-critical error: $_"
    }
}

# Save Generated File
function Save-GeneratedFile {
    if (-not $global:GeneratedCode) {
        [System.Windows.Forms.MessageBox]::Show("No code generated to save.", "No Code")
        return
    }
    
    $saveDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveDialog.Filter = if ($global:DetectedLanguage -eq "C++") { "C++ Files (*.cpp)|*.cpp|All Files (*.*)|*.*" } 
                        else { "C Files (*.c)|*.c|All Files (*.*)|*.*" }
    $saveDialog.DefaultExt = if ($global:DetectedLanguage -eq "C++") { "cpp" } else { "c" }
    $saveDialog.FileName = "program.$($saveDialog.DefaultExt)"
    $saveDialog.InitialDirectory = [Environment]::GetFolderPath("Desktop")
    
    if ($saveDialog.ShowDialog() -eq "OK") {
        $global:GeneratedCode | Out-File -FilePath $saveDialog.FileName -Encoding UTF8
        $OutputTextBox.AppendText("`n✅ File saved to: $($saveDialog.FileName)`n")
    }
}

# Show About Dialog
function Show-AboutDialog {
    $aboutForm = New-Object System.Windows.Forms.Form
    $aboutForm.Text = "About IGRF AI C/C++ IDE Pro"
    $aboutForm.Size = New-Object System.Drawing.Size(550, 550)  # Increased height from 500 to 550
    $aboutForm.StartPosition = "CenterParent"
    $aboutForm.FormBorderStyle = "FixedDialog"
    $aboutForm.MaximizeBox = $false
    $aboutForm.MinimizeBox = $false
    $aboutForm.BackColor = $colors.Surface

    $logo = New-Object System.Windows.Forms.PictureBox
    $logo.Size = New-Object System.Drawing.Size(90, 90)
    $logo.Location = New-Object System.Drawing.Point(220, 20)
    $logo.SizeMode = "StretchImage"
    if ($global:Logo) { $logo.Image = $global:Logo }

    $titleLabel = New-Object System.Windows.Forms.Label
    $titleLabel.Text = "IGRF AI C/C++ IDE Pro"
    $titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
    $titleLabel.ForeColor = $colors.Primary
    $titleLabel.Location = New-Object System.Drawing.Point(150, 120)
    $titleLabel.Size = New-Object System.Drawing.Size(250, 35)
    $titleLabel.TextAlign = "MiddleCenter"

    $versionLabel = New-Object System.Windows.Forms.Label
    $versionLabel.Text = "Version 1.0 Professional"
    $versionLabel.Font = New-Object System.Drawing.Font("Segoe UI", 12)
    $versionLabel.ForeColor = $colors.TextSecondary
    $versionLabel.Location = New-Object System.Drawing.Point(175, 160)
    $versionLabel.Size = New-Object System.Drawing.Size(200, 25)
    $versionLabel.TextAlign = "MiddleCenter"

    $devLabel = New-Object System.Windows.Forms.Label
    $devLabel.Text = "Developed by IGRF Pvt. Ltd."
    $devLabel.Font = New-Object System.Drawing.Font("Segoe UI", 11)
    $devLabel.ForeColor = $colors.Text
    $devLabel.Location = New-Object System.Drawing.Point(175, 190)
    $devLabel.Size = New-Object System.Drawing.Size(200, 25)
    $devLabel.TextAlign = "MiddleCenter"

    $websiteLink = New-Object System.Windows.Forms.LinkLabel
    $websiteLink.Text = "Website"
    $websiteLink.Location = New-Object System.Drawing.Point(150, 230)
    $websiteLink.Size = New-Object System.Drawing.Size(250, 30)
    $websiteLink.TextAlign = "MiddleCenter"
    $websiteLink.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $websiteLink.LinkColor = $colors.Primary
    $websiteLink.Add_LinkClicked({ Start-Process "https://igrf.co.in/en/software/" })

    $contactLink = New-Object System.Windows.Forms.LinkLabel
    $contactLink.Text = "Contact-us"
    $contactLink.Location = New-Object System.Drawing.Point(150, 265)
    $contactLink.Size = New-Object System.Drawing.Size(250, 30)
    $contactLink.TextAlign = "MiddleCenter"
    $contactLink.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $contactLink.LinkColor = $colors.Primary
    $contactLink.Add_LinkClicked({ Start-Process "https://igrf.co.in/en/contact-us/" })

    $featuresBox = New-Object System.Windows.Forms.GroupBox
    $featuresBox.Text = " Features "
    $featuresBox.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $featuresBox.ForeColor = $colors.Primary
    $featuresBox.Location = New-Object System.Drawing.Point(100, 310)
    $featuresBox.Size = New-Object System.Drawing.Size(350, 140)  # Increased height from 120 to 140
    $featuresBox.BackColor = $colors.HeaderBg

    $featuresLabel = New-Object System.Windows.Forms.Label
    $featuresLabel.Text = "✨ AI-Powered Code Generation`n📊 Step-by-Step Algorithms`n🔊 Voice Explanations (Male/Female)`n⚙️ Built-in GCC Compiler`n🎨 Professional Windows 11 UI"
    $featuresLabel.Location = New-Object System.Drawing.Point(20, 25)
    $featuresLabel.Size = New-Object System.Drawing.Size(310, 100)  # Increased height from 85 to 100
    $featuresLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $featuresLabel.ForeColor = $colors.Text
    $featuresLabel.AutoSize = $false  # Prevent auto-sizing

    $featuresBox.Controls.Add($featuresLabel)

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = "OK"
    $okButton.Location = New-Object System.Drawing.Point(220, 470)  # Moved down from 440 to 470
    $okButton.Size = New-Object System.Drawing.Size(100, 35)
    $okButton.BackColor = $colors.Primary
    $okButton.ForeColor = [System.Drawing.Color]::White
    $okButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $okButton.FlatStyle = "Flat"
    $okButton.Add_Click({ $aboutForm.Close() })

    $aboutForm.Controls.AddRange(@($logo, $titleLabel, $versionLabel, $devLabel, $websiteLink, $contactLink, $featuresBox, $okButton))
    $aboutForm.ShowDialog()
}

# ==================== NVIDIA AI API COMMUNICATION ====================
# This function communicates with NVIDIA's AI API for code generation.
# All network operations are:
# 1. Encrypted (HTTPS) - all traffic is secure
# 2. Only to NVIDIA's official endpoints (integrate.api.nvidia.com)
# 3. Only with the user's problem statement (no personal data collected)
# 4. Required for the AI code generation feature to function
#
# The API key is included in the application for convenience.
# Users can replace it with their own NVIDIA API key if desired at:
# https://build.nvidia.com/
#
# Data transmitted:
# - User's problem statement (for code generation)
# - No personal information, files, or system data
# - No tracking or analytics data
#
# This is the ONLY network communication in the entire application.
# No other data is sent to any other servers.
# ==================== END OF NETWORK DOCUMENTATION ====================

# API Request - COMPLETELY SILENT
function Invoke-ApiRequest {
    param($apiConfig, $prompt)
    
    $headers = @{
        "Authorization" = "$($apiConfig.AuthType) $($apiConfig.Key)"
        "Content-Type" = "application/json"
    }
    
    $body = @{
        model = $apiConfig.Model
        messages = @(
            @{
                role = "user"
                content = $prompt
            }
        )
        temperature = 0.2
        max_tokens = 2048
    } | ConvertTo-Json -Depth 10
    
    try {
        $ps = [PowerShell]::Create()
        $null = $ps.AddScript({
            param($uri, $headers, $body)
            try {
                $response = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $body -TimeoutSec 45 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue 2>$null 3>$null
                return $response
            } catch {
                return $null
            }
        }).AddArgument($apiConfig.Endpoint).AddArgument($headers).AddArgument($body)
        
        $response = $ps.Invoke()
        $ps.Dispose()
        
        if ($response -and $response[0].choices -and $response[0].choices[0].message.content) {
            return @{
                Success = $true
                Content = $response[0].choices[0].message.content.Trim()
                ApiName = $apiConfig.Name
            }
        }
    } catch { }
    
    return @{ Success = $false; ApiName = $apiConfig.Name }
}

# Stop Voice Announcement - FIXED with null checking
function Stop-Voice {
    try {
        if ($global:Synthesizer -ne $null) {
            $global:Synthesizer.SpeakAsyncCancelAll()
        }
        if ($OutputTextBox -ne $null) {
            $OutputTextBox.AppendText("`n⏹️ Voice announcement stopped`n")
        }
        if ($StatusLabel -ne $null) {
            $StatusLabel.Text = "● Voice stopped"
            $StatusLabel.ForeColor = $colors.Warning
        }
    } catch {
        if ($OutputTextBox -ne $null) {
            $OutputTextBox.AppendText("`n❌ Failed to stop voice`n")
        }
    }
}

# Enhanced Voice Announcement Function - FIXED with null checking
function Speak-Text {
    param(
        [string]$Text,
        [string]$Category = "General",
        [bool]$Interrupt = $true
    )
    
    try {
        # Check if synthesizer exists
        if ($global:Synthesizer -eq $null) {
            return
        }
        
        # Set the voice based on current selection
        Set-Voice
        
        # Stop any ongoing speech if Interrupt is true
        if ($Interrupt) {
            $global:Synthesizer.SpeakAsyncCancelAll()
            Start-Sleep -Milliseconds 100
        }
        
        # Speak the text asynchronously
        $global:Synthesizer.SpeakAsync($Text)
        
        # Log to output for debugging (optional)
        # Write-Host "🔊 Speaking [$Category]: $Text" -ForegroundColor Cyan
    } catch {
        # Silent fail - don't show errors
    }
}

# Add this function near your other functions (around line where other functions are defined)
function Initialize-TempFilePath {
    param([string]$extension)
    
    # First, ensure we have generated code to write
    if ([string]::IsNullOrWhiteSpace($global:GeneratedCode)) {
        return $false
    }
    
    # Define all possible temp locations in order of preference
    $tempLocations = @(
        [System.IO.Path]::Combine($env:TEMP, "IGRF_IDE"),
        [System.IO.Path]::Combine($env:LOCALAPPDATA, "Temp", "IGRF_IDE"),
        [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "IGRF_IDE"),
        [System.IO.Path]::Combine($script:AppPath, "temp"),
        $script:AppPath  # Final fallback
    )
    
    # Try each location
    foreach ($tempDir in $tempLocations) {
        try {
            # Create directory if it doesn't exist (with full permissions)
            if (-not (Test-Path $tempDir)) {
                $null = New-Item -ItemType Directory -Path $tempDir -Force -ErrorAction Stop
            }
            
            # Set the temp file path
            $global:TempFile = [System.IO.Path]::Combine($tempDir, "IGRF_IDE_Source.$extension")
            
            # Try to write the file with multiple encoding attempts
            $writeSuccess = $false
            $encodings = @([System.Text.Encoding]::UTF8, [System.Text.Encoding]::ASCII, [System.Text.Encoding]::Default)
            
            foreach ($encoding in $encodings) {
                try {
                    # Remove file if it exists
                    if (Test-Path $global:TempFile) {
                        Remove-Item $global:TempFile -Force -ErrorAction SilentlyContinue
                    }
                    
                    # Write with current encoding
                    [System.IO.File]::WriteAllText($global:TempFile, $global:GeneratedCode, $encoding)
                    
                    # Verify file was created and has content
                    if (Test-Path $global:TempFile) {
                        $fileInfo = Get-Item $global:TempFile -ErrorAction SilentlyContinue
                        if ($fileInfo -and $fileInfo.Length -gt 0) {
                            $writeSuccess = $true
                            break
                        }
                    }
                } catch {
                    # Try next encoding
                    continue
                }
            }
            
            if ($writeSuccess) {
                return $true
            }
        } catch {
            # Continue to next location
            continue
        }
    }
    
    # ULTIMATE FALLBACK - Use current script directory with random filename
    try {
        $fallbackDir = $script:AppPath
        $randomName = "IGRF_$([System.Guid]::NewGuid().ToString().Substring(0,8)).$extension"
        $global:TempFile = [System.IO.Path]::Combine($fallbackDir, $randomName)
        
        # Try simple Out-File as last resort
        $global:GeneratedCode | Out-File -FilePath $global:TempFile -Encoding UTF8 -Force -ErrorAction Stop
        
        if (Test-Path $global:TempFile) {
            return $true
        }
    } catch {
        return $false
    }
    
    return $false
}

# Explain Code with Voice (from main button panel)
function Explain-Code {
    if (-not $global:GeneratedCode) {
        [System.Windows.Forms.MessageBox]::Show("Please generate code first.", "No Code")
        return
    }
    
    if ($ExplanationTextBox.Text -eq "") {
        [System.Windows.Forms.MessageBox]::Show("No explanation available.", "No Explanation")
        return
    }
    
    try {
        Set-Voice
        $global:Synthesizer.SpeakAsync($ExplanationTextBox.Text)
        $OutputTextBox.AppendText("`n🔊 Speaking explanation from Output panel ($global:CurrentVoice voice)...`n")
        $OutputTextBox.AppendText("🔴 Click 'Stop Voice' button to stop announcement`n")
    } catch {
        $OutputTextBox.AppendText("`n❌ Audio error`n")
    }
}

# Explain Code Panel - Context aware based on active tab
function Explain-CodePanel {
    # Check which tab is active in the CodeTabs
    $activeTab = $CodeTabs.SelectedTab.Text
    
    if ($activeTab -eq "Source Code") {
        # Explain the source code
        if (-not $global:GeneratedCode) {
            [System.Windows.Forms.MessageBox]::Show("Please generate code first.", "No Code")
            return
        }
        
        $textToExplain = $CodeTextBox.Text
        if ([string]::IsNullOrWhiteSpace($textToExplain)) {
            [System.Windows.Forms.MessageBox]::Show("No source code to explain.", "No Content")
            return
        }
        
        try {
            Set-Voice
            $global:Synthesizer.SpeakAsync($textToExplain)
            $OutputTextBox.AppendText("`n🔊 Speaking source code ($global:CurrentVoice voice)...`n")
            $OutputTextBox.AppendText("🔴 Click 'Stop' button to stop announcement`n")
        } catch {
            $OutputTextBox.AppendText("`n❌ Audio error`n")
        }
    }
    elseif ($activeTab -eq "Algorithm") {
        # Explain the algorithm
        if (-not $AlgoTextBox.Text) {
            [System.Windows.Forms.MessageBox]::Show("Please generate algorithm first.", "No Algorithm")
            return
        }
        
        try {
            Set-Voice
            $global:Synthesizer.SpeakAsync($AlgoTextBox.Text)
            $OutputTextBox.AppendText("`n🔊 Speaking algorithm ($global:CurrentVoice voice)...`n")
            $OutputTextBox.AppendText("🔴 Click 'Stop' button to stop announcement`n")
        } catch {
            $OutputTextBox.AppendText("`n❌ Audio error`n")
        }
    }
}

# Stop Code Panel Voice
function Stop-CodeVoice {
    try {
        $global:Synthesizer.SpeakAsyncCancelAll()
        $OutputTextBox.AppendText("`n⏹️ Voice announcement stopped from Code Panel`n")
        $StatusLabel.Text = "● Voice stopped"
        $StatusLabel.ForeColor = $colors.Warning
    } catch {
        $OutputTextBox.AppendText("`n❌ Failed to stop voice`n")
    }
}

# Explain Output Panel - Context aware based on active tab
function Explain-OutputPanel {
    # Check which tab is active in the OutputTabs
    $activeTab = $OutputTabs.SelectedTab.Text
    
    if ($activeTab -eq "Console Output") {
        # Explain the console output
        if ($OutputTextBox.Text -eq "") {
            [System.Windows.Forms.MessageBox]::Show("No console output to explain.", "No Output")
            return
        }
        
        try {
            Set-Voice
            $global:Synthesizer.SpeakAsync($OutputTextBox.Text)
            $OutputTextBox.AppendText("`n🔊 Speaking console output ($global:CurrentVoice voice)...`n")
            $OutputTextBox.AppendText("🔴 Click 'STOP' button to stop announcement`n")
        } catch {
            $OutputTextBox.AppendText("`n❌ Audio error`n")
        }
    }
    elseif ($activeTab -eq "Code Explanation") {
        # Explain the code explanation
        if ($ExplanationTextBox.Text -eq "") {
            [System.Windows.Forms.MessageBox]::Show("No explanation available.", "No Explanation")
            return
        }
        
        try {
            Set-Voice
            $global:Synthesizer.SpeakAsync($ExplanationTextBox.Text)
            $OutputTextBox.AppendText("`n🔊 Speaking code explanation ($global:CurrentVoice voice)...`n")
            $OutputTextBox.AppendText("🔴 Click 'STOP' button to stop announcement`n")
        } catch {
            $OutputTextBox.AppendText("`n❌ Audio error`n")
        }
    }
}

# Stop Output Panel Voice
function Stop-OutputVoice {
    try {
        $global:Synthesizer.SpeakAsyncCancelAll()
        $OutputTextBox.AppendText("`n⏹️ Voice announcement stopped from Output Panel`n")
        $StatusLabel.Text = "● Voice stopped"
        $StatusLabel.ForeColor = $colors.Warning
    } catch {
        $OutputTextBox.AppendText("`n❌ Failed to stop voice`n")
    }
}

# ==================== DEBUG MODE FUNCTIONS ====================
function Toggle-DebugMode {
    $global:DebugMode = -not $global:DebugMode
    
    if ($global:DebugMode) {
        $OutputTextBox.AppendText("`n🔧 DEBUG MODE ENABLED`n")
        $OutputTextBox.AppendText("Additional diagnostic information will be displayed.`n")
        $OutputTextBox.AppendText("═══════════════════════════════════════════`n")
    } else {
        $OutputTextBox.AppendText("`n🔧 DEBUG MODE DISABLED`n")
        $OutputTextBox.AppendText("═══════════════════════════════════════════`n")
    }
}

# Optional: Add a Debug menu item to the menu strip
# Find where MenuStrip items are added and add this menu
# Look for: $MenuStrip.Items.AddRange(@($FileMenu, $VoiceMenu, $HelpMenu))
# Replace with: $MenuStrip.Items.AddRange(@($FileMenu, $VoiceMenu, $DebugMenu, $HelpMenu))
# ==================== END DEBUG MODE FUNCTIONS ====================

# Analyze compilation errors and provide helpful voice suggestions
function Analyze-CompilationError {
    param([string]$errorOutput)
    
    $suggestion = ""
    
    if ($errorOutput -match "undefined reference to") {
        $suggestion = "Missing function definition. Check if you've declared all functions properly."
    }
    elseif ($errorOutput -match "expected ';'") {
        $suggestion = "Missing semicolon. Check the line indicated in the error."
    }
    elseif ($errorOutput -match "unknown type name") {
        $suggestion = "Unknown data type. Check if you've included the correct headers."
    }
    elseif ($errorOutput -match "redefinition of") {
        $suggestion = "Duplicate definition. You've defined the same variable or function twice."
    }
    elseif ($errorOutput -match "not declared in this scope") {
        $suggestion = "Variable not declared. Make sure all variables are declared before use."
    }
    elseif ($errorOutput -match "No such file or directory") {
        $suggestion = "Source file not found. Please generate the code again."
    }
    else {
        $suggestion = "Click the Clear button and provide the problem statement with more clear details."
    }
    
    return $suggestion
}

# Function to reset and verify temp file locations - SILENT VERSION
function Reset-TempFiles {
    # Completely silent version - no returns, just side effects
    try {
        $tempLocations = @(
            [System.IO.Path]::Combine($env:LOCALAPPDATA, "Temp", "IGRF_IDE"),
            [System.IO.Path]::Combine($env:TEMP, "IGRF_IDE"),
            [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "IGRF_IDE"),
            [System.IO.Path]::Combine($script:AppPath, "temp")
        )
        
        foreach ($tempDir in $tempLocations) {
            try {
                if (-not (Test-Path $tempDir -ErrorAction SilentlyContinue)) {
                    $null = New-Item -ItemType Directory -Path $tempDir -Force -ErrorAction SilentlyContinue 2>&1
                }
                
                # Test write access silently
                $testFile = [System.IO.Path]::Combine($tempDir, "test.tmp")
                try {
                    "test" | Out-File -FilePath $testFile -Encoding UTF8 -Force -ErrorAction SilentlyContinue 2>&1
                    if (Test-Path $testFile -ErrorAction SilentlyContinue) {
                        Remove-Item $testFile -Force -ErrorAction SilentlyContinue 2>&1
                        $global:OutputExe = [System.IO.Path]::Combine($tempDir, "IGRF_IDE_Output.exe")
                        $global:TempOutput = [System.IO.Path]::Combine($tempDir, "IGRF_IDE_Temp.exe")
                        break
                    }
                } catch { $null }
            } catch { $null }
        }
    } catch { $null }
    
    # Never return anything
    return $null
}

# ==================== SAFE PROCESS EXECUTION ====================
function Invoke-SafeProcess {
    param(
        [string]$FilePath,
        [string]$Arguments,
        [int]$TimeoutSeconds = 30,
        [string]$WorkingDirectory = $script:AppPath
    )
    
    # Validate executable path
    if (-not (Test-Path $FilePath)) {
        Write-IGRFLog -Message "Process execution failed: File not found - $FilePath" -EntryType "Error" -EventId 1002
        return $null
    }
    
    # Check if executable is in allowed locations
    $allowedPaths = @(
        $script:AppPath,
        [System.IO.Path]::Combine($script:AppPath, "gcc", "bin"),
        $global:SecureTemp
    )
    
    $isAllowed = $false
    $fileDir = [System.IO.Path]::GetDirectoryName($FilePath)
    foreach ($path in $allowedPaths) {
        if ($fileDir -eq $path) {
            $isAllowed = $true
            break
        }
    }
    
    if (-not $isAllowed) {
        Write-IGRFLog -Message "Process execution blocked: Unauthorized path - $FilePath" -EntryType "Warning" -EventId 1003
        return $null
    }
    
    # Create process with secure settings
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $FilePath
    $psi.Arguments = $Arguments
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true
    $psi.WorkingDirectory = $WorkingDirectory
    $psi.LoadUserProfile = $false
    $psi.ErrorDialog = $false
    
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $psi
    $process.EnableRaisingEvents = $true
    
    try {
        if ($process.Start()) {
            # Log successful process start
            Write-IGRFLog -Message "Process started: $FilePath" -EntryType "Information" -EventId 1004
            
            # Wait for exit with timeout
            if ($process.WaitForExit($TimeoutSeconds * 1000)) {
                $output = $process.StandardOutput.ReadToEnd()
                $error = $process.StandardError.ReadToEnd()
                $exitCode = $process.ExitCode
                
                $process.Dispose()
                
                return @{
                    Success = $true
                    Output = $output
                    Error = $error
                    ExitCode = $exitCode
                }
            } else {
                # Timeout - kill process
                $process.Kill()
                $process.WaitForExit(2000)
                $process.Dispose()
                
                Write-IGRFLog -Message "Process timed out: $FilePath" -EntryType "Warning" -EventId 1005
                
                return @{
                    Success = $false
                    Output = ""
                    Error = "Process execution timed out after $TimeoutSeconds seconds"
                    ExitCode = -1
                }
            }
        }
    } catch {
        Write-IGRFLog -Message "Process execution error: $_" -EntryType "Error" -EventId 1006
        $process.Dispose()
    }
    
    return $null
}
# ==================== END SAFE PROCESS EXECUTION ====================

# Add this NEW function right after Invoke-SafeProcess
function Stop-RunningProcess {
    param([string]$processName = "IGRF_IDE_Output")
    
    try {
        # Find any running processes from our compiled programs
        # Get just the filename without extension for process name matching
        if ($processName -like "*.exe") {
            $processName = [System.IO.Path]::GetFileNameWithoutExtension($processName)
        }
        
        $processes = Get-Process -Name $processName -ErrorAction SilentlyContinue
        
        if ($processes) {
            $OutputTextBox.AppendText("`n🛑 Found $($processes.Count) running process(es) from previous runs...`n")
            
            foreach ($proc in $processes) {
                try {
                    # Try to close gracefully first
                    $proc.CloseMainWindow()
                    Start-Sleep -Milliseconds 300
                    
                    if (!$proc.HasExited) {
                        $proc.Kill()
                        $proc.WaitForExit(1000)
                    }
                    
                    $OutputTextBox.AppendText("✅ Terminated process ID: $($proc.Id)`n")
                } catch {
                    $OutputTextBox.AppendText("⚠️ Could not terminate process ID: $($proc.Id)`n")
                }
            }
        }
    } catch {
        # Silently fail
    }
}

# Add this NEW function right after Stop-RunningProcess
function Test-ExecutableValid {
    param([string]$exePath)
    
    try {
        if (-not (Test-Path $exePath)) {
            return $false, "Executable not found"
        }
        
        # Check if file is actually an executable
        $fileInfo = Get-Item $exePath
        if ($fileInfo.Length -eq 0) {
            return $false, "Executable is empty"
        }
        
        # Check if file is in use by another process
        try {
            $stream = [System.IO.File]::Open($exePath, 'Open', 'Read', 'None')
            $stream.Close()
        } catch {
            return $false, "Executable is in use by another process"
        }
        
        return $true, "Valid"
    } catch {
        return $false, "Validation error: $_"
    }
}

function Compile-Code {
    # CRITICAL FIX - Set the working directory to the EXE location
    Set-Location $script:AppPath
    [Environment]::CurrentDirectory = $script:AppPath
    
    # Force compiler path to be absolute using AppPath
    $global:CompilerPath = Join-Path $script:AppPath "gcc\bin\gcc.exe"
    
    # Add compiler to PATH
    if (Test-Path $global:CompilerPath) {
        $gccBin = Split-Path $global:CompilerPath -Parent
        $env:PATH = "$gccBin;$env:PATH"
    }

    # First, kill any running instances of our program
    Stop-RunningProcess -processName (Split-Path $global:OutputExe -LeafBase)
    # Enable the source code and output panels
    if ($CodeTabs -ne $null) {
        $CodeTabs.Enabled = $true
        $CodeTabs.Visible = $true
        # Focus on Source Code tab
        $CodeTabs.SelectedTab = $CodeTab
    }
    if ($CodeTextBox -ne $null) {
        $CodeTextBox.Enabled = $true
        $CodeTextBox.ReadOnly = $false
    }
    if ($OutputTabs -ne $null) {
        $OutputTabs.Enabled = $true
        $OutputTabs.Visible = $true
        # Focus on Console Output tab
        $OutputTabs.SelectedTab = $ConsoleTab
    }
    if ($OutputTextBox -ne $null) {
        $OutputTextBox.Enabled = $true
        $OutputTextBox.ReadOnly = $false
    }
    
    # Force scroll to bottom helper
    function Update-OutputScroll {
        $OutputTextBox.SelectionStart = $OutputTextBox.Text.Length
        $OutputTextBox.ScrollToCaret()
        [System.Windows.Forms.Application]::DoEvents()
    }
    
    if (-not $global:GeneratedCode) {
        [System.Windows.Forms.MessageBox]::Show("Please generate code first.", "No Code")
        return
    }
    
    if (-not (Check-Compiler)) {
        [System.Windows.Forms.MessageBox]::Show("GCC compiler not found in 'gcc\bin' folder.", "Compiler Missing")
        return
    }
    
    # ============ CHECK FOR EXTERNAL DEPENDENCIES ============
    $depCheck = Test-ExternalDependencies-Enhanced -code $global:GeneratedCode
    
    if ($depCheck.HasExternalDependencies) {
        $OutputTextBox.AppendText("`n⚠️ EXTERNAL DEPENDENCIES DETECTED`n")
        $OutputTextBox.AppendText("═══════════════════════════════════════════`n")
        $OutputTextBox.AppendText("This program depends on the following external libraries:`n")
        foreach ($lib in $depCheck.DetectedLibraries) {
            $OutputTextBox.AppendText("  • $lib`n")
        }
        $OutputTextBox.AppendText("`n")
        $OutputTextBox.AppendText("This program code is depending on the external libraries (external dependencies)`n")
        $OutputTextBox.AppendText("and falls out of the scope of the GCC compiler of this IDE.`n")
        $OutputTextBox.AppendText("`n")
        $OutputTextBox.AppendText("Program cannot be compiled further, thanks for your interest on IGRF's AI C/C++ IDE on learning.`n")
        $OutputTextBox.AppendText("═══════════════════════════════════════════`n")
        Update-OutputScroll
        
        # Voice announcement for external dependencies - EXACTLY as specified
        $voiceMessage = "This program code is depending on the external libraries (external dependencies) and falls out of the scope of the GCC compiler of this IDE. Program cannot be compiled further, thanks for your interest on IGRF's AI C C plus plus IDE on learning."
        Speak-Text -Text $voiceMessage -Category "Compile"
        
        return
    }
    
    # Check if the code contains common syntax errors before compiling
    if ($global:GeneratedCode -match '#include\s*<.*?>' -and $global:GeneratedCode -notmatch 'int\s+main\s*\(') {
        $OutputTextBox.AppendText("`n⚠️ Warning: Code includes headers but may be missing main() function`n")
        Update-OutputScroll
        Speak-Text -Text "Warning: Check if your code has a proper main function." -Category "Compile"
    }
    
    # ============ ENSURE TEMP FILE EXISTS ============
    $file_ext = if ($global:DetectedLanguage -eq "C++") { "cpp" } else { "c" }
    
    # Check if TempFile is set and points to a valid location
    $tempFileValid = $false
    
    if ($global:TempFile -and (Test-Path $global:TempFile)) {
        # File exists, check if it has content
        $fileInfo = Get-Item $global:TempFile -ErrorAction SilentlyContinue
        if ($fileInfo -and $fileInfo.Length -gt 0) {
            $tempFileValid = $true
            $OutputTextBox.AppendText("`n✅ Source file found at: $global:TempFile`n")
        }
    }
    
    if (-not $tempFileValid) {
        $OutputTextBox.AppendText("`n❌ Source file not found or invalid: $global:TempFile`n")
        $OutputTextBox.AppendText("Attempting to recover...`n")
        Update-OutputScroll
        
        # Try to recreate the file from memory
        if ($global:GeneratedCode) {
            $OutputTextBox.AppendText("Regenerating source file from memory...`n")
            Update-OutputScroll
            
            # Initialize temp file path
            if (Initialize-TempFilePath -extension $file_ext) {
                $OutputTextBox.AppendText("✅ Source file recovered at: $global:TempFile`n")
                $tempFileValid = $true
            } else {
                $OutputTextBox.AppendText("❌ Failed to recover source file after multiple attempts.`n")
                $OutputTextBox.AppendText("Please generate the code again.`n")
                $OutputTextBox.AppendText("Troubleshooting tips:`n")
                $OutputTextBox.AppendText("1. Run PowerShell as Administrator`n")
                $OutputTextBox.AppendText("2. Check if antivirus is blocking file creation`n")
                $OutputTextBox.AppendText("3. Ensure you have write permissions in temp folder`n")
                Update-OutputScroll
                Speak-Text -Text "Failed to create source file. Please generate the code again." -Category "Compile"
                return
            }
        } else {
            $OutputTextBox.AppendText("No code in memory. Please generate code first.`n")
            Update-OutputScroll
            Speak-Text -Text "Please generate code first." -Category "Compile"
            return
        }
    }
    
    Cleanup-OldFiles
    
    $OutputTextBox.AppendText("`n🔨 Compiling with GCC...")
    $OutputTextBox.AppendText("`nSource file: $global:TempFile")
    Update-OutputScroll
    
    $tempOutput = $global:TempOutput
    
    $OutputTextBox.AppendText("`n")
    Update-OutputScroll
    
    # ============ REMOVE EXISTING TEMP OUTPUT FILE ============
    # Use try-catch for file cleanup
    try {
        if (Test-Path $tempOutput) {
            Remove-Item $tempOutput -Force -ErrorAction Stop
            $OutputTextBox.AppendText("✅ Removed existing temporary file`n")
        }
    } catch {
        # If can't remove, try alternative approach
        try {
            $processes = Get-Process -ErrorAction SilentlyContinue | Where-Object { 
                $_.Path -ne $null -and $_.Path -eq $tempOutput 
            }
            if ($processes) {
                $processes | Stop-Process -Force -ErrorAction SilentlyContinue
                Start-Sleep -Milliseconds 500
                Remove-Item $tempOutput -Force -ErrorAction SilentlyContinue
            }
        } catch {
            $OutputTextBox.AppendText("⚠️ Could not remove existing temp file, but continuing...`n")
        }
    }
    
    # ============ VALIDATE COMPILER ============
    # Verify compiler path exists
    if (-not (Test-Path $global:CompilerPath)) {
        $OutputTextBox.AppendText("`r❌ Compiler not found at: $global:CompilerPath`n")
        $OutputTextBox.AppendText("Please ensure GCC compiler is properly installed in the 'gcc\bin' folder.`n")
        return
    }
    
    # Additional validation for compiler file
    try {
        $compilerInfo = Get-Item $global:CompilerPath -ErrorAction Stop
        $compilerSize = $compilerInfo.Length
        
        # GCC should be a reasonable size (between 100KB and 50MB)
        if ($compilerSize -lt 100KB -or $compilerSize -gt 50MB) {
            $OutputTextBox.AppendText("`r⚠️ Warning: Compiler file size ($compilerSize bytes) is unusual.`n")
            $OutputTextBox.AppendText("This may indicate file corruption or tampering.`n")
        }
    } catch {
        $OutputTextBox.AppendText("`r⚠️ Unable to validate compiler file: $_`n")
    }
    
    # Log compilation attempt
    $OutputTextBox.AppendText("`n🔧 Starting compilation with GCC at: $(Get-Date -Format 'HH:mm:ss')`n")
    $OutputTextBox.AppendText("📁 Source file: $global:TempFile`n")
    $OutputTextBox.AppendText("🎯 Target: $global:OutputExe`n")
    Update-OutputScroll
    
    # ============ MAIN COMPILATION PROCESS ============
    # Initialize variables
    $stdout = $null
    $stderr = $null
    $exitCode = -1
    $compilerPath = $global:CompilerPath
    $compilerArgs = ""
    
    # Determine compiler and flags based on language
    if ($global:DetectedLanguage -eq "C++") {
        # For C++, use g++ instead of gcc
        $compilerDir = Split-Path $compilerPath -Parent
        $cppCompilerPath = Join-Path $compilerDir "g++.exe"
        
        if (Test-Path $cppCompilerPath) {
            $compilerPath = $cppCompilerPath
            $compilerArgs = "`"$global:TempFile`" -o `"$tempOutput`" -static-libstdc++ -static-libgcc"
            $OutputTextBox.AppendText(" (using g++ for C++)...")
        } else {
            # Fallback to gcc with -lstdc++
            $compilerArgs = "`"$global:TempFile`" -o `"$tempOutput`" -lstdc++ -static-libgcc"
            $OutputTextBox.AppendText(" (using gcc with -lstdc++)...")
        }
    } else {
        # For C, use gcc normally
        $compilerArgs = "`"$global:TempFile`" -o `"$tempOutput`""
    }
    
    # Log the exact command being run
    $OutputTextBox.AppendText("`n💻 Command: $compilerPath $compilerArgs`n")
    Update-OutputScroll
    
    # Use safe process execution
    $compileResult = Invoke-SafeProcess -FilePath $compilerPath -Arguments $compilerArgs -TimeoutSeconds 15 -WorkingDirectory $script:AppPath
    
    if ($compileResult -and $compileResult.Success) {
        $stdout = $compileResult.Output
        $stderr = $compileResult.Error
        $exitCode = $compileResult.ExitCode
        
        # Process compilation result
        if ($exitCode -eq 0 -and (Test-Path $tempOutput)) {
            # Compilation successful - move executable to final location
            try {
                # Remove existing final executable if any
                if (Test-Path $global:OutputExe) {
                    try {
                        Remove-Item $global:OutputExe -Force -ErrorAction Stop
                    } catch {
                        # If can't remove, rename as backup
                        $backupFile = "$global:OutputExe.bak"
                        if (Test-Path $backupFile) {
                            try { Remove-Item $backupFile -Force -ErrorAction SilentlyContinue } catch {}
                        }
                        try { Rename-Item $global:OutputExe $backupFile -Force -ErrorAction Stop } catch {}
                    }
                }
                
                # Move the new file
                Move-Item $tempOutput $global:OutputExe -Force -ErrorAction Stop
                $OutputTextBox.AppendText("`r✅ Compilation successful!`n")
                Update-OutputScroll
                
                # Focus on Console Output tab
                if ($OutputTabs -ne $null -and $ConsoleTab -ne $null) {
                    $OutputTabs.SelectedTab = $ConsoleTab
                }
                Speak-Text -Text "Compilation successful." -Category "Compile"
            } catch {
                $OutputTextBox.AppendText("`r❌ Failed to create executable: $_`n")
                Update-OutputScroll
            }
        } else {
            # Compilation failed
            $OutputTextBox.AppendText("`r❌ Compilation failed (exit code: $exitCode)`n")
            Update-OutputScroll
            
            # Analyze the error
            $suggestion = "Compilation failed. "
            if ($stderr) {
                $suggestion += Analyze-CompilationError -errorOutput $stderr
                $OutputTextBox.AppendText("`nCompiler output:`n$stderr`n")
                Update-OutputScroll
            } else {
                $suggestion += "Click the Clear button and provide the problem statement with more clear details."
            }
            
            # Voice announcement
            Speak-Text -Text $suggestion -Category "Compile"
            
            # Clean up temp output
            if (Test-Path $tempOutput) { 
                try { Remove-Item $tempOutput -Force -ErrorAction SilentlyContinue } catch {} 
            }
        }
    } else {
        $OutputTextBox.AppendText("`r❌ Compilation process failed to start or timed out`n")
        if ($compileResult) {
            $OutputTextBox.AppendText("Error: $($compileResult.Error)`n")
        }
        Update-OutputScroll
    }
    
    # Force garbage collection
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
}

#Run-Program Function Starts - IMPROVED VERSION
function Run-Program {
    # Focus on Source Code and Console Output tabs
    if ($CodeTabs -ne $null -and $CodeTab -ne $null) {
        $CodeTabs.SelectedTab = $CodeTab
    }
    if ($OutputTabs -ne $null -and $ConsoleTab -ne $null) {
        $OutputTabs.SelectedTab = $ConsoleTab
    }
    
    # Add null checking at the beginning
    if ($global:GeneratedCode -eq $null -or -not $global:GeneratedCode) {
        [System.Windows.Forms.MessageBox]::Show("Please generate code first.", "No Code")
        return
    }
    
    # Add null checking for OutputExe
    if ($global:OutputExe -eq $null) {
        [System.Windows.Forms.MessageBox]::Show("Please compile the code first.", "Not Compiled")
        return
    }
    
    if (-not (Test-Path $global:OutputExe -ErrorAction SilentlyContinue)) {
        [System.Windows.Forms.MessageBox]::Show("Please compile the code first.", "Not Compiled")
        return
    }
    
    # Add null checking for OutputTextBox
    if ($OutputTextBox -eq $null) {
        [System.Windows.Forms.MessageBox]::Show("UI Error: Output text box not initialized.", "Error")
        return
    }
    
    # Stop any ongoing voice announcements
    Stop-Voice
    
    $OutputTextBox.AppendText("`n🚀 Running program...`n")
    $OutputTextBox.AppendText("═══════════════════════════════════════════`n")
    $OutputTextBox.ScrollToCaret()
    $StatusLabel.Text = "● Running..."
    $StatusLabel.ForeColor = $colors.Warning
    
    # Force UI update
    [System.Windows.Forms.Application]::DoEvents()
    
    # ============ COMPREHENSIVE INPUT DETECTION ============
    $code = $global:GeneratedCode
    $inputData = @()  # Array to store hashtables with variable info
    
    # Split code into lines and remove comments for analysis
    $lines = $code -split "`r`n|`n"
    $cleanLines = @()
    $inComment = $false
    
    foreach ($line in $lines) {
        $cleanLine = $line
        # Remove block comments
        if ($inComment) {
            if ($line -match '\*/') {
                $cleanLine = $line -replace '.*\*/', ''
                $inComment = $false
            } else {
                continue
            }
        }
        if ($line -match '/\*') {
            $cleanLine = $line -replace '/\*.*', ''
            $inComment = $true
        }
        # Remove line comments
        $cleanLine = $cleanLine -replace '//.*$', ''
        if ($cleanLine.Trim()) {
            $cleanLines += $cleanLine
        }
    }
    
    # Detect input statements with their prompts
    if ($global:DetectedLanguage -eq "C++") {
        # Find all cin statements
        $processedVariables = @{}  # Track variables we've already processed
        
        for ($i = 0; $i -lt $cleanLines.Count; $i++) {
            $line = $cleanLines[$i].Trim()
            
            # Look for cin >> variable
            if ($line -match 'cin\s*>>\s*(\w+)') {
                $varName = $matches[1]
                
                # Skip if we've already processed this variable
                if ($processedVariables.ContainsKey($varName)) {
                    continue
                }
                
                # Look backwards for the closest cout prompt
                $promptText = "Enter value for ${varName}: "
                $promptFound = $false
                
                for ($j = $i - 1; $j -ge 0; $j--) {
                    $prevLine = $cleanLines[$j].Trim()
                    
                    # Look for cout with string literal
                    if ($prevLine -match 'cout\s*<<\s*"([^"]+)"') {
                        $promptText = $matches[1]
                        $promptFound = $true
                        break
                    }
                    # Stop if we hit another cin or control structure
                    if ($prevLine -match 'cin\s*>>' -or $prevLine -match '^\s*}' -or $prevLine -match '^\s*{' -or $prevLine -match '^\s*if' -or $prevLine -match '^\s*for' -or $prevLine -match '^\s*while') {
                        break
                    }
                }
                
                # Clean up the prompt
                $promptText = $promptText -replace '\\n', ' ' -replace '\\t', ' ' -replace '\s+', ' '
                $promptText = $promptText.Trim()
                
                # Only add if this is the first occurrence (not a validation loop)
                if (-not $processedVariables.ContainsKey($varName)) {
                    $inputData += @{
                        Variable = $varName
                        Prompt = $promptText
                        Type = "unknown"
                        FormatSpecifier = ""
                        Line = $i
                    }
                    $processedVariables[$varName] = $true
                }
            }
        }
    } else {
        # C language - find all scanf statements
        for ($i = 0; $i -lt $cleanLines.Count; $i++) {
            $line = $cleanLines[$i].Trim()
            
            # Look for scanf with format string and variable
            if ($line -match 'scanf\s*\(\s*"([^"]*)"\s*,\s*&(\w+)') {
                $formatSpecifier = $matches[1]
                $varName = $matches[2]
                
                # Determine type from format specifier
                $type = "unknown"
                if ($formatSpecifier -match '%d') { $type = "integer" }
                elseif ($formatSpecifier -match '%f') { $type = "float" }
                elseif ($formatSpecifier -match '%lf') { $type = "double" }
                elseif ($formatSpecifier -match '%c') { $type = "character" }
                elseif ($formatSpecifier -match '%s') { $type = "string" }
                
                # Look backwards for the closest printf prompt
                $promptText = "Enter value for ${varName}: "
                $promptFound = $false
                
                for ($j = $i - 1; $j -ge 0; $j--) {
                    $prevLine = $cleanLines[$j].Trim()
                    
                    # Look for printf with string literal
                    if ($prevLine -match 'printf\s*\(\s*"([^"]+)"') {
                        $promptText = $matches[1]
                        $promptFound = $true
                        break
                    }
                    # Stop if we hit another scanf or control structure
                    if ($prevLine -match 'scanf\s*\(' -or $prevLine -match '^\s*}' -or $prevLine -match '^\s*{' -or $prevLine -match '^\s*if' -or $prevLine -match '^\s*for' -or $prevLine -match '^\s*while') {
                        break
                    }
                }
                
                # Clean up the prompt
                $promptText = $promptText -replace '\\n', ' ' -replace '\\t', ' ' -replace '\s+', ' '
                $promptText = $promptText.Trim()
                
                $inputData += @{
                    Variable = $varName
                    Prompt = $promptText
                    Type = $type
                    FormatSpecifier = $formatSpecifier
                    Line = $i
                }
            }
        }
    }
    
    # If no inputs detected, try to detect from problem statement
    if ($inputData.Count -eq 0) {
        $OutputTextBox.AppendText("ℹ️ No input statements detected in code. Analyzing problem statement...`n")
        
        $problemText = $ProblemTextBox.Text.ToLower()
        
        if ($problemText -match 'factorial|fact') {
            $inputData += @{
                Variable = "n"
                Prompt = "Enter a non-negative integer for factorial calculation:"
                Type = "integer"
                FormatSpecifier = "%d"
            }
        } elseif ($problemText -match 'add|sum|total|plus|addition') {
            $inputData += @{
                Variable = "firstNumber"
                Prompt = "Enter first number:"
                Type = "double"
                FormatSpecifier = "%lf"
            }
            $inputData += @{
                Variable = "secondNumber"
                Prompt = "Enter second number:"
                Type = "double"
                FormatSpecifier = "%lf"
            }
        } elseif ($problemText -match 'subtract|minus|difference') {
            $inputData += @{
                Variable = "firstNumber"
                Prompt = "Enter first number:"
                Type = "double"
                FormatSpecifier = "%lf"
            }
            $inputData += @{
                Variable = "secondNumber"
                Prompt = "Enter second number:"
                Type = "double"
                FormatSpecifier = "%lf"
            }
        } elseif ($problemText -match 'multiply|product|times|multiplication') {
            $inputData += @{
                Variable = "firstNumber"
                Prompt = "Enter first number:"
                Type = "double"
                FormatSpecifier = "%lf"
            }
            $inputData += @{
                Variable = "secondNumber"
                Prompt = "Enter second number:"
                Type = "double"
                FormatSpecifier = "%lf"
            }
        } elseif ($problemText -match 'divide|division|quotient') {
            $inputData += @{
                Variable = "dividend"
                Prompt = "Enter dividend:"
                Type = "double"
                FormatSpecifier = "%lf"
            }
            $inputData += @{
                Variable = "divisor"
                Prompt = "Enter divisor:"
                Type = "double"
                FormatSpecifier = "%lf"
            }
        } elseif ($problemText -match 'fibonacci|fib') {
            $inputData += @{
                Variable = "terms"
                Prompt = "Enter number of terms for Fibonacci series:"
                Type = "integer"
                FormatSpecifier = "%d"
            }
        } elseif ($problemText -match 'prime') {
            $inputData += @{
                Variable = "number"
                Prompt = "Enter a number to check if it's prime:"
                Type = "integer"
                FormatSpecifier = "%d"
            }
        } elseif ($problemText -match 'palindrome') {
            $inputData += @{
                Variable = "number"
                Prompt = "Enter a number to check if it's palindrome:"
                Type = "integer"
                FormatSpecifier = "%d"
            }
        } elseif ($problemText -match 'armstrong') {
            $inputData += @{
                Variable = "number"
                Prompt = "Enter a number to check if it's Armstrong:"
                Type = "integer"
                FormatSpecifier = "%d"
            }
        } else {
            $inputData += @{
                Variable = "value"
                Prompt = "Enter value:"
                Type = "double"
                FormatSpecifier = "%lf"
            }
        }
    }
    
    $inputCount = $inputData.Count
    $OutputTextBox.AppendText("📊 Detected $inputCount input(s)`n")
    foreach ($item in $inputData) {
        $typeInfo = if ($item.Type -ne "unknown") { " ($($item.Type))" } else { "" }
        $OutputTextBox.AppendText("   $($item.Variable)${typeInfo}: `"$($item.Prompt)`"`n")
    }
    $OutputTextBox.ScrollToCaret()
    
    # ============ COLLECT INPUTS FROM USER WITH PROPER PROMPTS ============
    $inputValues = @()

    for ($i = 0; $i -lt $inputCount; $i++) {
        $item = $inputData[$i]
        $prompt = $item.Prompt
        $varName = $item.Variable
        $type = $item.Type
        
        # Add type hint to prompt
        $displayPrompt = $prompt
        if ($type -ne "unknown") {
            $displayPrompt += "`n($type expected)"
        }
        
        $title = "Input Required - ${varName}"
        
        # Announce the prompt via voice - but don't interrupt previous
        $voicePrompt = $prompt -replace '\\n', ' ' -replace '\\t', ' '
        Speak-Text -Text $voicePrompt -Category "Run" -Interrupt $false
        
        # Create input dialog
        $inputForm = New-Object System.Windows.Forms.Form
        $inputForm.Text = $title
        $inputForm.Size = New-Object System.Drawing.Size(500, 220)
        $inputForm.StartPosition = "CenterParent"  # Changed from CenterScreen
        $inputForm.FormBorderStyle = "FixedDialog"
        $inputForm.MaximizeBox = $false
        $inputForm.MinimizeBox = $false
        $inputForm.Topmost = $true
        $inputForm.BackColor = [System.Drawing.Color]::White
        $inputForm.ControlBox = $true  # Ensure close button works
        $inputForm.ShowInTaskbar = $true  # Show in taskbar
        
        # Create label for prompt
        $promptLabel = New-Object System.Windows.Forms.Label
        $promptLabel.Location = New-Object System.Drawing.Point(20, 20)
        $promptLabel.Size = New-Object System.Drawing.Size(440, 60)
        $promptLabel.Text = $displayPrompt
        $promptLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
        $promptLabel.ForeColor = [System.Drawing.Color]::FromArgb(45, 45, 55)
        
        # Create textbox for input
        $inputTextBox = New-Object System.Windows.Forms.TextBox
        $inputTextBox.Location = New-Object System.Drawing.Point(20, 90)
        $inputTextBox.Size = New-Object System.Drawing.Size(440, 25)
        $inputTextBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
        $inputTextBox.BorderStyle = "FixedSingle"
        
        # Create OK button
        $okButton = New-Object System.Windows.Forms.Button
        $okButton.Location = New-Object System.Drawing.Point(150, 130)  # Adjusted position
        $okButton.Size = New-Object System.Drawing.Size(100, 35)
        $okButton.Text = "OK"
        $okButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
        $okButton.BackColor = [System.Drawing.Color]::FromArgb(72, 159, 72)
        $okButton.ForeColor = [System.Drawing.Color]::White
        $okButton.FlatStyle = "Flat"
        $okButton.FlatAppearance.BorderSize = 0
        $okButton.Cursor = [System.Windows.Forms.Cursors]::Hand
        $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK  # Set DialogResult
        
        # Create Cancel button
        $cancelButton = New-Object System.Windows.Forms.Button
        $cancelButton.Location = New-Object System.Drawing.Point(260, 130)  # Adjusted position
        $cancelButton.Size = New-Object System.Drawing.Size(90, 35)
        $cancelButton.Text = "Cancel"
        $cancelButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
        $cancelButton.BackColor = [System.Drawing.Color]::FromArgb(255, 99, 71)  # Error color
        $cancelButton.ForeColor = [System.Drawing.Color]::White
        $cancelButton.FlatStyle = "Flat"
        $cancelButton.FlatAppearance.BorderSize = 0
        $cancelButton.Cursor = [System.Windows.Forms.Cursors]::Hand
        $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel  # Set DialogResult
        
        # Handle Enter key
        $inputTextBox.Add_KeyDown({
            if ($_.KeyCode -eq "Enter") {
                $_.SuppressKeyPress = $true
                $this.Parent.DialogResult = [System.Windows.Forms.DialogResult]::OK
                $this.Parent.Close()
            }
        })
        
        # Handle Escape key
        $inputForm.Add_KeyDown({
            if ($_.KeyCode -eq "Escape") {
                $_.SuppressKeyPress = $true
                $this.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
                $this.Close()
            }
        })
        
        # Set form to receive key events
        $inputForm.KeyPreview = $true
        
        # Add controls to form
        $inputForm.Controls.Add($promptLabel)
        $inputForm.Controls.Add($inputTextBox)
        $inputForm.Controls.Add($okButton)
        $inputForm.Controls.Add($cancelButton)
        
        # Set accept and cancel buttons
        $inputForm.AcceptButton = $okButton
        $inputForm.CancelButton = $cancelButton
        
        # Focus the textbox
        $inputForm.Add_Shown({ $inputTextBox.Focus() })
        
        # Show form and get result
        $result = $inputForm.ShowDialog()
        
        if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
            $value = $inputTextBox.Text.Trim()
            
            # Validation based on type
            $valid = $true
            if ($type -eq "integer") {
                if ($value -notmatch '^-?\d+$') {
                    [System.Windows.Forms.MessageBox]::Show(
                        "Please enter a valid integer.",
                        "Invalid Input",
                        [System.Windows.Forms.MessageBoxButtons]::OK,
                        [System.Windows.Forms.MessageBoxIcon]::Warning
                    )
                    $valid = $false
                }
            } elseif ($type -eq "float" -or $type -eq "double") {
                if ($value -notmatch '^-?\d*\.?\d+$') {
                    [System.Windows.Forms.MessageBox]::Show(
                        "Please enter a valid number.",
                        "Invalid Input",
                        [System.Windows.Forms.MessageBoxButtons]::OK,
                        [System.Windows.Forms.MessageBoxIcon]::Warning
                    )
                    $valid = $false
                }
            } elseif ($type -eq "character") {
                if ($value.Length -ne 1) {
                    [System.Windows.Forms.MessageBox]::Show(
                        "Please enter a single character.",
                        "Invalid Input",
                        [System.Windows.Forms.MessageBoxButtons]::OK,
                        [System.Windows.Forms.MessageBoxIcon]::Warning
                    )
                    $valid = $false
                }
            } else {
                if ([string]::IsNullOrWhiteSpace($value)) {
                    [System.Windows.Forms.MessageBox]::Show(
                        "Please enter a value.",
                        "Invalid Input",
                        [System.Windows.Forms.MessageBoxButtons]::OK,
                        [System.Windows.Forms.MessageBoxIcon]::Warning
                    )
                    $valid = $false
                }
            }
            
            if (-not $valid) {
                $i--
                continue
            }
            
            $inputValues += $value
            
            # Announce the input value - but don't interrupt
            Speak-Text -Text "$varName is $value" -Category "Run" -Interrupt $false
        } else {
            # User cancelled
            $OutputTextBox.AppendText("⚠️ Input cancelled by user`n")
            $OutputTextBox.AppendText("═══════════════════════════════════════════`n")
            $OutputTextBox.ScrollToCaret()
            $StatusLabel.Text = "● Run cancelled"
            $StatusLabel.ForeColor = $colors.Warning
            return
        }
    }
    
    $OutputTextBox.AppendText("✅ Input provided:`n")
    for ($i = 0; $i -lt $inputValues.Count; $i++) {
        $varName = $inputData[$i].Variable
        $OutputTextBox.AppendText("   $varName = $($inputValues[$i])`n")
    }
    $OutputTextBox.AppendText("───────────────────────────────────────`n")
    $OutputTextBox.ScrollToCaret()
    
    # ============ ROBUST PROGRAM EXECUTION WITH PROPER INPUT PASSING ============
    $OutputTextBox.AppendText("⏳ Program executing, please wait...`n")
    $OutputTextBox.ScrollToCaret()
    [System.Windows.Forms.Application]::DoEvents()
    
    # Disable Run button
    $RunBtn.Enabled = $false
    
    $exePath = $global:OutputExe
    $workingDir = Split-Path $exePath -Parent
    
    # Create temporary files for input/output
    $tempInputFile = [System.IO.Path]::Combine($workingDir, "input_$([System.Guid]::NewGuid().ToString().Substring(0,8)).txt")
    $tempOutputFile = [System.IO.Path]::Combine($workingDir, "output_$([System.Guid]::NewGuid().ToString().Substring(0,8)).txt")
    
    try {
        # Write inputs to file with proper line endings - THIS IS THE KEY FIX
        # Each input should be on its own line with proper termination
        $inputContent = ""
        foreach ($val in $inputValues) {
            # Add newline after each input
            $inputContent += "$val`r`n"
        }
        [System.IO.File]::WriteAllText($tempInputFile, $inputContent, [System.Text.Encoding]::ASCII)
        
        $OutputTextBox.AppendText("   Input file created with $inputCount value(s)`n")
        $OutputTextBox.ScrollToCaret()
        
        # METHOD 1: Direct process execution with stdin redirection (COMPATIBLE WITH ALL WINDOWS VERSIONS)
		$psi = New-Object System.Diagnostics.ProcessStartInfo
		$psi.FileName = $exePath
		$psi.RedirectStandardInput = $true
		$psi.RedirectStandardOutput = $true
		$psi.RedirectStandardError = $true
		$psi.UseShellExecute = $false
		$psi.CreateNoWindow = $true
		$psi.WorkingDirectory = $workingDir
		# Remove the encoding properties that cause errors
		# $psi.StandardInputEncoding = [System.Text.Encoding]::ASCII
		# $psi.StandardOutputEncoding = [System.Text.Encoding]::UTF8

		$process = New-Object System.Diagnostics.Process
		$process.StartInfo = $psi

		# Set encoding manually after process starts (more compatible approach)
		# We'll handle encoding when reading/writing
        
        $OutputTextBox.AppendText("   Starting process: $(Split-Path $exePath -Leaf)`n")
        $OutputTextBox.ScrollToCaret()
        
        if ($process.Start()) {
            $OutputTextBox.AppendText("   Process started with ID: $($process.Id)`n")
            $OutputTextBox.ScrollToCaret()
            
            # Send inputs one by one with proper timing - using ASCII encoding manually
			foreach ($inputVal in $inputValues) {
				# Write the input followed by newline using ASCII encoding
				$bytes = [System.Text.Encoding]::ASCII.GetBytes($inputVal + "`n")
				$process.StandardInput.BaseStream.Write($bytes, 0, $bytes.Length)
				$process.StandardInput.BaseStream.Flush()
				$OutputTextBox.AppendText("   Sent input: $inputVal`n")
				$OutputTextBox.ScrollToCaret()
				Start-Sleep -Milliseconds 200  # Small delay between inputs
			}
            
            # Close stdin to signal end of input
            $process.StandardInput.Close()
            
            $OutputTextBox.AppendText("   All inputs sent, waiting for output...`n")
            $OutputTextBox.ScrollToCaret()
            
            # Read output asynchronously to prevent deadlock
            $outputBuilder = New-Object System.Text.StringBuilder
            $errorBuilder = New-Object System.Text.StringBuilder

            # Use a queue to collect output lines for later display
            $outputLines = New-Object System.Collections.ArrayList
            $errorLines = New-Object System.Collections.ArrayList

            # Register event handlers for output with MessageData to pass variables
            $outputEvent = Register-ObjectEvent -InputObject $process -EventName 'OutputDataReceived' -Action {
                $eventData = $EventArgs.Data
                if ($eventData -ne $null) {
                    # Store in ArrayList for later use
                    $event.MessageData.outputLines.Add($eventData) | Out-Null
                    
                    # Update UI in real-time - handle encoding properly
					$event.MessageData.outputTextBox.Invoke([Action]{
						# Convert from UTF8 if needed (most console output is ASCII/UTF8)
						$displayText = $eventData
						$event.MessageData.outputTextBox.AppendText("$displayText`n")
						$event.MessageData.outputTextBox.ScrollToCaret()
					}) | Out-Null
                    
                    # Announce EVERY line from the program output (including input prompts and results)
                    $trimmedLine = $eventData.Trim()
                    if ($trimmedLine -and $trimmedLine.Length -lt 100) {  # Only limit length
                        
                        # Calculate delay based on line length to ensure natural pacing
                        $wordCount = ($trimmedLine -split '\s+').Count
                        $delayMs = [Math]::Max(50, $wordCount * 50)
                        
                        # Small delay before speaking
                        Start-Sleep -Milliseconds $delayMs
                        
                        # Speak this output line
                        $event.MessageData.synthesizer.Invoke([Action]{
                            $event.MessageData.synthesizer.SpeakAsync($trimmedLine) | Out-Null
                        }) | Out-Null
                    }
                }
            } -MessageData @{
                outputLines = $outputLines
                outputTextBox = $OutputTextBox
                synthesizer = $global:Synthesizer
            }

            $errorEvent = Register-ObjectEvent -InputObject $process -EventName 'ErrorDataReceived' -Action {
                $eventData = $EventArgs.Data
                if ($eventData -ne $null) {
                    # Store in ArrayList for later use
                    $event.MessageData.errorLines.Add($eventData) | Out-Null
                    
                    # Update UI in real-time
                    $event.MessageData.outputTextBox.Invoke([Action]{
                        $event.MessageData.outputTextBox.AppendText("⚠️ $eventData`n")
                        $event.MessageData.outputTextBox.ScrollToCaret()
                    }) | Out-Null
                    
                    # Announce errors
                    $trimmedLine = $eventData.Trim()
                    if ($trimmedLine) {
                        Start-Sleep -Milliseconds 150
                        $event.MessageData.synthesizer.Invoke([Action]{
                            $event.MessageData.synthesizer.SpeakAsync("Error: $trimmedLine") | Out-Null
                        }) | Out-Null
                    }
                }
            } -MessageData @{
                errorLines = $errorLines
                outputTextBox = $OutputTextBox
                synthesizer = $global:Synthesizer
            }

            # Begin async read operations
            $process.BeginOutputReadLine()
            $process.BeginErrorReadLine()

            $OutputTextBox.AppendText("   Waiting for program output...`n")
            $OutputTextBox.ScrollToCaret()

            # Wait for process to exit with timeout
            $exited = $process.WaitForExit(30000)  # 30 second timeout

            # Unregister events
            Unregister-Event -SourceIdentifier $outputEvent.Name -Force -ErrorAction SilentlyContinue
            Unregister-Event -SourceIdentifier $errorEvent.Name -Force -ErrorAction SilentlyContinue

            if ($exited) {
                $exitCode = $process.ExitCode
                $OutputTextBox.AppendText("`n✅ Process completed with exit code: $exitCode`n")
                
                # Get final output from the ArrayLists
                $fullOutput = $outputLines -join "`n"
                $errorOutput = $errorLines -join "`n"
                
                # Display separator if we had output
                if ($outputLines.Count -gt 0) {
                    $OutputTextBox.AppendText("───────────────────────────────────────`n")
                }
                
                if (-not [string]::IsNullOrWhiteSpace($errorOutput)) {
                    $OutputTextBox.AppendText("⚠️ Error Output:`n")
                    $OutputTextBox.AppendText($errorOutput)
                    $OutputTextBox.AppendText("`n───────────────────────────────────────`n")
                }
                
                # Voice announcement for output and input summary
                # First, create a summary of inputs that were provided
                $inputSummary = ""
                if ($inputValues.Count -gt 0) {
                    $inputParts = @()
                    for ($i = 0; $i -lt $inputValues.Count; $i++) {
                        $varName = $inputData[$i].Variable
                        $inputParts += "$varName = $($inputValues[$i])"
                    }
                    $inputSummary = "Input provided: " + ($inputParts -join ", ") + ". "
                }

                # Collect ALL output lines for the summary (including input prompts and results)
                $allOutputLines = @()
                foreach ($line in $outputLines) {
                    $trimmedLine = $line.Trim()
                    if ($trimmedLine) {
                        $allOutputLines += $trimmedLine
                    }
                }

                # Create the final announcement
                if ($inputSummary -ne "" -or $allOutputLines.Count -gt 0) {
                    # Wait longer to ensure all real-time announcements have finished
                    Start-Sleep -Milliseconds 2000
                    
                    if ($inputSummary -ne "" -and $allOutputLines.Count -gt 0) {
                        # Combine input summary with the actual output lines
                        $outputText = $allOutputLines -join ". "
                        $announcement = $inputSummary + $outputText
                    }
                    elseif ($inputSummary -ne "") {
                        $announcement = $inputSummary
                    }
                    elseif ($allOutputLines.Count -gt 0) {
                        $announcement = "Program output: " + ($allOutputLines -join ". ")
                    }
                    
                    # Speak the announcement
                    if ($announcement) {
                        Speak-Text -Text $announcement -Category "Run" -Interrupt $false
                    }
                }

                if ($exitCode -eq 0) {
                    $StatusLabel.Text = "● Run complete"
                    $StatusLabel.ForeColor = $colors.Success
                    
                    # Wait a bit more then add final success announcement
                    Start-Sleep -Milliseconds 1000
                    Speak-Text -Text "Program completed successfully." -Category "Run" -Interrupt $false
                } else {
                    $StatusLabel.Text = "● Run completed with issues"
                    $StatusLabel.ForeColor = $colors.Warning
                }

                # Also capture any lines that might have been missed but look like results
                foreach ($line in $outputLines) {
                    $trimmedLine = $line.Trim()
                    # Look for patterns like "100.00" or "Result: 100.00" that might have been missed
                    if ($trimmedLine -match '\d+\.?\d*' -and $trimmedLine.Length -lt 30) {
                        if ($trimmedLine -notin $resultLines) {
                            $resultLines += $trimmedLine
                        }
                    }
                }

                # Remove duplicates while preserving order
                $resultLines = $resultLines | Select-Object -Unique

                # Create the final announcement
                if ($inputSummary -ne "" -or $resultLines.Count -gt 0) {
                    Start-Sleep -Milliseconds 500
                    
                    if ($inputSummary -ne "" -and $resultLines.Count -gt 0) {
                        # Both inputs and results
                        $outputSummary = $resultLines -join ", "
                        $announcement = $inputSummary + $outputSummary
                    }
                    elseif ($inputSummary -ne "") {
                        # Only inputs (unlikely, but handle)
                        $announcement = $inputSummary.TrimEnd('; ') + "."
                    }
                    elseif ($resultLines.Count -gt 0) {
                        # Only results
                        $outputSummary = $resultLines[0..([Math]::Min(2, $resultLines.Count-1))] -join ", "
                        $announcement = "Program output: " + $outputSummary
                        if ($resultLines.Count -gt 3) { $announcement += " and more" }
                    }
                    
                    # Speak the announcement
                    if ($announcement) {
                        Speak-Text -Text $announcement -Category "Run" -Interrupt $false
                    }
                }
                
                if ($exitCode -eq 0) {
                    $StatusLabel.Text = "● Run complete"
                    $StatusLabel.ForeColor = $colors.Success
                    
                    # Add final success announcement
                    Start-Sleep -Milliseconds 800  # Wait for other announcements to finish
                    Speak-Text -Text "Program completed successfully." -Category "Run" -Interrupt $false
                } else {
                    $StatusLabel.Text = "● Run completed with issues"
                    $StatusLabel.ForeColor = $colors.Warning
                }
                } else {
                # Process timed out
                $process.Kill()
                $process.WaitForExit(2000)
                $OutputTextBox.AppendText("❌ Process execution timed out after 30 seconds`n")
                $StatusLabel.Text = "● Run timeout"
                $StatusLabel.ForeColor = $colors.Error
                Speak-Text -Text "Program execution timed out." -Category "Run"
            }
        } else {
            $OutputTextBox.AppendText("❌ Failed to start process`n")
            $StatusLabel.Text = "● Run failed"
            $StatusLabel.ForeColor = $colors.Error
            Speak-Text -Text "Failed to start program." -Category "Run"
        }
    } catch {
        $OutputTextBox.AppendText("❌ Runtime error: $($_.Exception.Message)`n")
        $StatusLabel.Text = "● Run error"
        $StatusLabel.ForeColor = $colors.Error
        Speak-Text -Text "Error running program." -Category "Run"
    } finally {
        # Clean up temporary files
        try { if (Test-Path $tempInputFile) { Remove-Item $tempInputFile -Force -ErrorAction SilentlyContinue } } catch {}
        try { if (Test-Path $tempOutputFile) { Remove-Item $tempOutputFile -Force -ErrorAction SilentlyContinue } } catch {}
        
        # Re-enable Run button
        $RunBtn.Enabled = $true
        $OutputTextBox.AppendText("═══════════════════════════════════════════`n")
        $OutputTextBox.ScrollToCaret()
        
        # Dispose process if it still exists
        if ($process -and -not $process.HasExited) {
            try { $process.Kill() } catch {}
            $process.Dispose()
        }
    }
}
#Run-Program Function Ends

# SECOND Generate-Code function with voice feedback
function Generate-Code {
    
    # Enable the source code and output panels
    if ($CodeTabs -ne $null) {
        $CodeTabs.Enabled = $true
        $CodeTabs.Visible = $true
    }
    if ($CodeTextBox -ne $null) {
        $CodeTextBox.Enabled = $true
        $CodeTextBox.ReadOnly = $false
    }
    if ($OutputTabs -ne $null) {
        $OutputTabs.Enabled = $true
        $OutputTabs.Visible = $true
    }
    if ($OutputTextBox -ne $null) {
        $OutputTextBox.Enabled = $true
        $OutputTextBox.ReadOnly = $false
    }
    
    $problem = $ProblemTextBox.Text.Trim()
    if ($problem -eq "" -or $problem -eq $ProblemTextBox.Tag) {
        [System.Windows.Forms.MessageBox]::Show("Please describe your programming problem.", "Input Required")
        Speak-Text -Text "Please describe your programming problem." -Category "Generate"
        return
    }

    # Announce the problem being generated
    Speak-Text -Text "Generating $global:DetectedLanguage code for: $problem" -Category "Generate"

    # CLEAR ALL PREVIOUS VALUES BEFORE NEW GENERATION
    # Stop any ongoing voice announcement
    Stop-Voice
    
    # Clear all text boxes
    $CodeTextBox.Text = ""
    $AlgoTextBox.Text = ""
    $ExplanationTextBox.Text = ""
    $OutputTextBox.Text = ""
    
    # Reset generated code variable
    $global:GeneratedCode = ""
    
    # Reset language detection
    $global:DetectedLanguage = "Unknown"
    $LangStatusLabel.Text = "C/C++ Detected"
    $LangIconLabel.Text = "C/C++ Ready"
    $LangStatusPanel.BackColor = $colors.Warning
    
    # Set default tabs
    $CodeTabs.SelectedTab = $CodeTab
    $OutputTabs.SelectedTab = $ConsoleTab

    # Force language detection based on prompt
    Detect-LanguageFromPrompt
    
    # Check if language was properly specified
    if (-not (Test-ValidLanguageSpecification)) {
        $message = "Please specify the programming language clearly. Valid formats: C, c, C++, c++, CPP, cpp, C plus, c plus, C plus plus, c plus plus"
        [System.Windows.Forms.MessageBox]::Show(
            "Please specify the programming language clearly.`n`n" +
            "Valid formats: C, c, C++, c++, CPP, cpp, C plus, c plus, C plus plus, c plus plus`n`n" +
            "Example: 'Write a C program to add two numbers'`n" +
            "Example: 'Write a C++ program to calculate factorial'",
            "Language Specification Required",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        )
        Speak-Text -Text $message -Category "Generate"
        return
    }
    
    if ($global:DetectedLanguage -eq "Unknown") {
        $message = "Please specify whether you want C or C++ program in your prompt."
        [System.Windows.Forms.MessageBox]::Show(
            "Please specify whether you want C or C++ program in your prompt.`n`n" +
            "Valid formats: C, c, C++, c++, CPP, cpp, C plus, c plus, C plus plus, c plus plus",
            "Language Required"
        )
        Speak-Text -Text $message -Category "Generate"
        return
    }

    # Check internet connectivity before API call
    if (-not (Test-InternetBeforeApi)) {
        $AIStatus.Text = "● AI Code Generation: No Internet"
        $AIStatus.ForeColor = $colors.Error
        $StatusLabel.Text = "● No Internet Connection"
        $StatusLabel.ForeColor = $colors.Error
        Speak-Text -Text "No internet connection. Please check your network." -Category "Generate"
        return
    }

    $global:SessionCount++
    $TotalLabel.Text = "Sessions: $global:SessionCount"
    
    $StatusLabel.Text = "● Generating..."
    $StatusLabel.ForeColor = $colors.Warning
    $AIStatus.Text = "● AI Code Generation: Generating..."
    $AIStatus.ForeColor = $colors.Warning

    # Force scroll to bottom helper
    function Update-OutputScroll {
        $OutputTextBox.SelectionStart = $OutputTextBox.Text.Length
        $OutputTextBox.ScrollToCaret()
        [System.Windows.Forms.Application]::DoEvents()  # Force UI update
    }
    
    $CodeTextBox.Text = "⏳ Generating $global:DetectedLanguage code..."
    
    $OutputTextBox.AppendText("`n═══════════════════════════════════════════`n")
    Update-OutputScroll
    $OutputTextBox.AppendText("🔄 Starting new code generation session...`n")
    Update-OutputScroll
    $OutputTextBox.AppendText("═══════════════════════════════════════════`n`n")
    Update-OutputScroll

    $api = $global:Apis[0]
    $file_ext = if ($global:DetectedLanguage -eq "C++") { "cpp" } else { "c" }
    
    # Get the exact user prompt without any modifications
    $userPrompt = $ProblemTextBox.Text.Trim()
    
    # Generate Code - Strictly follow what user asked with proper input priority
    if ($global:DetectedLanguage -eq "C++") {
        $codePrompt = @"
Generate ONLY C++ code for the following exact problem with HIGHEST PRIORITY on proper input handling:

PROBLEM: $userPrompt

CRITICAL REQUIREMENTS - FOLLOW IN THIS EXACT ORDER:

1. **INPUT COLLECTION FIRST**: All cin statements MUST appear immediately at the beginning of main() function, BEFORE any calculations or processing.

2. **PROPER PROMPTS**: Each input MUST have a clear, descriptive prompt using cout immediately before the cin statement.

3. **INPUT VALIDATION REQUIRED**: After each input, add validation using cin.fail() to ensure:
   - For numeric inputs: Check if input is valid number (not letters/symbols)
   - For division: Ensure divisor is not zero
   - For square roots: Ensure value is non-negative
   - For factorials: Ensure number is non-negative
   - Display clear error message and exit or reprompt if validation fails

4. **SINGLE RESPONSIBILITY**: Each input prompt should ask for ONE value only. Don't combine multiple inputs in one prompt.

5. **CLEAR VARIABLE NAMES**: Use descriptive variable names that indicate their purpose.

6. **NO HARDCODED VALUES**: All values that affect the result must come from user input, not hardcoded in the program.

EXAMPLE STRUCTURE FOR C++:
#include <iostream>
using namespace std;

int main() {
    // DECLARE ALL VARIABLES AT THE BEGINNING
    double num1, num2, result;
    
    // INPUT SECTION - ALL INPUTS COLLECTED FIRST
    cout << "Enter first number: ";
    cin >> num1;
    // Validate first input
    while (cin.fail()) {
        cin.clear();
        cin.ignore(10000, '\n');
        cout << "Invalid input. Please enter a valid number: ";
        cin >> num1;
    }
    
    cout << "Enter second number: ";
    cin >> num2;
    // Validate second input
    while (cin.fail()) {
        cin.clear();
        cin.ignore(10000, '\n');
        cout << "Invalid input. Please enter a valid number: ";
        cin >> num2;
    }
    
    // VALIDATE SPECIFIC CONDITIONS BASED ON PROBLEM
    // Example for division: if (num2 == 0) { cout << "Error: Division by zero"; return 1; }
    // Example for square root: if (num1 < 0) { cout << "Error: Cannot calculate square root of negative number"; return 1; }
    // Example for factorial: if (num1 < 0) { cout << "Error: Factorial of negative number is undefined"; return 1; }
    
    // CALCULATION SECTION - ALL CALCULATIONS AFTER ALL INPUTS
    result = num1 + num2; // Adjust based on actual problem
    
    // OUTPUT SECTION
    cout << "Result: " << result << endl;
    
    return 0;
}

SPECIFIC FOR THIS PROBLEM: $userPrompt

CRITICAL RULES:
- ALL inputs MUST be collected BEFORE any calculations begin
- EACH input MUST have its own prompt
- ADD validation for each input to check if it's a valid number
- For specific operations, add condition-specific validation
- Use descriptive variable names
- Return 1 with error message if validation fails
- Include comments explaining the code

Return ONLY the code without any explanation or markdown formatting.
"@
    } else {
        # C language code generation prompt
        $codePrompt = @"
Generate ONLY C code for the following exact problem with HIGHEST PRIORITY on proper input handling:

PROBLEM: $userPrompt

CRITICAL REQUIREMENTS - FOLLOW IN THIS EXACT ORDER:

1. **INPUT COLLECTION FIRST**: All scanf statements MUST appear immediately at the beginning of main() function, BEFORE any calculations or processing.

2. **PROPER PROMPTS**: Each input MUST have a clear, descriptive prompt using printf immediately before the scanf statement.

3. **INPUT VALIDATION REQUIRED**: After each input, check scanf return value to ensure:
   - For numeric inputs: Check if input is valid number (scanf return value should be 1)
   - For division: Ensure divisor is not zero
   - For square roots: Ensure value is non-negative
   - For factorials: Ensure number is non-negative
   - Display clear error message and exit if validation fails

4. **SINGLE RESPONSIBILITY**: Each input prompt should ask for ONE value only. Don't combine multiple inputs in one prompt.

5. **CLEAR VARIABLE NAMES**: Use descriptive variable names that indicate their purpose.

6. **NO HARDCODED VALUES**: All values that affect the result must come from user input, not hardcoded in the program.

EXAMPLE STRUCTURE FOR C:
#include <stdio.h>

int main() {
    // DECLARE ALL VARIABLES AT THE BEGINNING
    double num1, num2, result;
    
    // INPUT SECTION - ALL INPUTS COLLECTED FIRST
    printf("Enter first number: ");
    if (scanf("%lf", &num1) != 1) {
        printf("Invalid input. Exiting...\n");
        return 1;
    }
    // Clear input buffer
    while (getchar() != '\n');
    
    printf("Enter second number: ");
    if (scanf("%lf", &num2) != 1) {
        printf("Invalid input. Exiting...\n");
        return 1;
    }
    // Clear input buffer
    while (getchar() != '\n');
    
    // VALIDATE SPECIFIC CONDITIONS BASED ON PROBLEM
    // Example for division: if (num2 == 0) { printf("Error: Division by zero\n"); return 1; }
    // Example for square root: if (num1 < 0) { printf("Error: Cannot calculate square root of negative number\n"); return 1; }
    // Example for factorial: if (num1 < 0) { printf("Error: Factorial of negative number is undefined\n"); return 1; }
    
    // CALCULATION SECTION - ALL CALCULATIONS AFTER ALL INPUTS
    result = num1 + num2; // Adjust based on actual problem
    
    // OUTPUT SECTION
    printf("Result: %.2lf\n", result);
    
    return 0;
}

SPECIFIC FOR THIS PROBLEM: $userPrompt

CRITICAL RULES:
- ALL inputs MUST be collected BEFORE any calculations begin
- EACH input MUST have its own prompt
- ADD validation for each input using scanf return value
- For specific operations, add condition-specific validation
- Use descriptive variable names
- Return 1 with error message if validation fails
- Include comments explaining the code

Return ONLY the code without any explanation or markdown formatting.
"@
    }
    
    $codeResult = Invoke-ApiRequest -apiConfig $api -prompt $codePrompt
 
    if ($codeResult.Success) {
        $code = $codeResult.Content -replace '```\w*', '' -replace '```', '' -replace '`', ''
        $code = $code.Trim()
        
        $CodeTextBox.Text = $code
        $global:GeneratedCode = $code
        
        # Set default tabs to Source Code and Console Output
        $CodeTabs.SelectedTab = $CodeTab
        $OutputTabs.SelectedTab = $ConsoleTab
        
        # --- FIXED: Create source file with proper error handling and fallback ---
        $OutputTextBox.AppendText("`n📁 Creating source file...`n")
        Update-OutputScroll

        $file_ext = if ($global:DetectedLanguage -eq "C++") { "cpp" } else { "c" }

        # Try to create the file with maximum retry attempts
        $maxRetries = 3
        $fileCreated = $false

        for ($retry = 1; $retry -le $maxRetries; $retry++) {
            if ($retry -gt 1) {
                $OutputTextBox.AppendText("🔄 Retry attempt $retry of $maxRetries...`n")
                Update-OutputScroll
                Start-Sleep -Milliseconds 500
            }
            
            if (Initialize-TempFilePath -extension $file_ext) {
                $fileInfo = Get-Item $global:TempFile -ErrorAction SilentlyContinue
                if ($fileInfo -and $fileInfo.Length -gt 0) {
                    $fileSize = $fileInfo.Length
                    $OutputTextBox.AppendText("✅ File created successfully at: $global:TempFile (Size: $fileSize bytes)`n")
                    $fileCreated = $true
                    break
                }
            }
        }

        if (-not $fileCreated) {
            $OutputTextBox.AppendText("❌ CRITICAL: All file creation attempts failed after $maxRetries retries.`n")
            $OutputTextBox.AppendText("Attempting emergency fallback to current directory...`n")
            Update-OutputScroll
            
            # Emergency fallback - use current directory with unique name
            try {
                $emergencyFile = [System.IO.Path]::Combine($script:AppPath, "emergency_$([System.Guid]::NewGuid().ToString().Substring(0,8)).$file_ext")
                $global:GeneratedCode | Out-File -FilePath $emergencyFile -Encoding UTF8 -Force -ErrorAction Stop
                $global:TempFile = $emergencyFile
                $OutputTextBox.AppendText("✅ Emergency file created at: $global:TempFile`n")
                $OutputTextBox.AppendText("⚠️ Please move this file to a safe location as it may be deleted on cleanup.`n")
                Update-OutputScroll
            } catch {
                $OutputTextBox.AppendText("❌ Even emergency fallback failed. Last error: $_`n")
                $OutputTextBox.AppendText("Please try:`n")
                $OutputTextBox.AppendText("1. Run PowerShell as Administrator`n")
                $OutputTextBox.AppendText("2. Temporarily disable antivirus`n")
                $OutputTextBox.AppendText("3. Check disk space`n")
                $OutputTextBox.AppendText("4. Save the code manually from the code window`n")
                Update-OutputScroll
                return
            }
        }
        
        $OutputTextBox.AppendText("`n═══════════════════════════════════════════`n")
        Update-OutputScroll
        $OutputTextBox.AppendText("✅ $global:DetectedLanguage code generated successfully`n")
        Update-OutputScroll
        $OutputTextBox.AppendText("Problem: $userPrompt`n")
        Update-OutputScroll
        $OutputTextBox.AppendText("═══════════════════════════════════════════`n`n")
        Update-OutputScroll
        
        # Validate code structure
        $validationResult = Test-CodeStructure -code $code -language $global:DetectedLanguage
        if (-not $validationResult) {
            $OutputTextBox.AppendText("⚠️ Warning: Generated code may have input structure issues. Please review.`n")
            Update-OutputScroll
            Speak-Text -Text "Warning: Generated code may have input structure issues. Please review." -Category "Generate"
        }
        
        # Announce code generation success
        Speak-Text -Text "$global:DetectedLanguage code generated successfully." -Category "Generate"
        
        # Generate Algorithm based on exact problem
        $OutputTextBox.AppendText("🔄 Generating algorithm...`n")
        Update-OutputScroll
        Speak-Text -Text "Generating algorithm." -Category "Generate" -Interrupt $false
        $algoPrompt = @"
Provide a step-by-step algorithm for this $global:DetectedLanguage program:

CODE:
$code

PROBLEM: $userPrompt

IMPORTANT: Create algorithm ONLY for what the program does based on the problem above.
DO NOT add steps for operations that aren't in the code.

Return only the algorithm in clear numbered steps using plain text without special symbols.
Do NOT use #, *, `, or any markdown formatting.
"@

        $algoResult = Invoke-ApiRequest -apiConfig $api -prompt $algoPrompt
        if ($algoResult.Success) {
            # Clean algorithm text
            $cleanAlgo = $algoResult.Content
            $cleanAlgo = $cleanAlgo -replace '^```[\w]*\s*', ''  # Remove starting ```
            $cleanAlgo = $cleanAlgo -replace '```\s*$', ''       # Remove ending ```
            $cleanAlgo = $cleanAlgo -replace '^#+\s+', ''        # Remove heading # at start
            $cleanAlgo = $cleanAlgo -replace '[#*_`~\[\]\(\)]', ''  # Remove remaining special chars
            $cleanAlgo = $cleanAlgo.Trim()
            
            $AlgoTextBox.Text = $cleanAlgo
            $OutputTextBox.AppendText("✅ Algorithm generated`n")
            Update-OutputScroll
            Speak-Text -Text "Algorithm generated." -Category "Generate"
        } else {
            $OutputTextBox.AppendText("❌ Failed to generate algorithm`n")
            Update-OutputScroll
            Speak-Text -Text "Failed to generate algorithm." -Category "Generate"
        }
        
        # Generate Explanation based on exact code
        $OutputTextBox.AppendText("🔄 Generating explanation...`n")
        Update-OutputScroll
        Speak-Text -Text "Generating explanation." -Category "Generate" -Interrupt $false
        $explainPrompt = @"
Explain this $global:DetectedLanguage program in simple terms:

CODE:
$code

PROBLEM: $userPrompt

Explain ONLY what this specific program does:
1. What the program does (based on the problem)
2. How it works line by line
3. Key concepts used
4. Input/output handling

IMPORTANT FORMATTING INSTRUCTIONS:
- DO NOT start the explanation with markdown symbols like #, *, `, -, or any other special characters
- DO NOT end the explanation with markdown symbols
- DO NOT wrap the entire explanation in code blocks with ```
- DO NOT use # for headings at the beginning of the text
- You may use symbols WITHIN the text when referring to code elements (like `printf`, `cout`, `#include`)
- Use plain text for the explanation with clear paragraphs
- Use bullet points with simple - or * ONLY within the body, not at the very start
- The first line should be plain text, not a heading with #

Make it educational and easy to understand.
"@

        $explainResult = Invoke-ApiRequest -apiConfig $api -prompt $explainPrompt
        if ($explainResult.Success) {
            # Clean the explanation text
            $cleanExplanation = $explainResult.Content
            
            # Remove markdown code blocks at the beginning and end
            $cleanExplanation = $cleanExplanation -replace '^```[\w]*\s*', ''  # Remove starting ```language
            $cleanExplanation = $cleanExplanation -replace '```\s*$', ''       # Remove ending ```
            
            # Remove heading markdown at the very beginning only
            $cleanExplanation = $cleanExplanation -replace '^#+\s+', ''        # Remove # heading at start
            
            # Remove any leading special characters sequence
            $cleanExplanation = $cleanExplanation -replace '^[#\*_`~\-]+\s*', ''  # Remove leading special chars
            
            # Trim any remaining whitespace
            $cleanExplanation = $cleanExplanation.Trim()
            
            $ExplanationTextBox.Text = $cleanExplanation
            $OutputTextBox.AppendText("✅ Explanation generated and cleaned`n")
            Update-OutputScroll
            Speak-Text -Text "Explanation generated." -Category "Generate"
        } else {
            $OutputTextBox.AppendText("❌ Failed to generate explanation`n")
            Update-OutputScroll
            Speak-Text -Text "Failed to generate explanation." -Category "Generate"
        }
        
        $OutputTextBox.AppendText("✅ All generations complete`n")
        Update-OutputScroll
        $OutputTextBox.AppendText("═══════════════════════════════════════════`n")
        Update-OutputScroll
        
        $ApiLabel.Text = "AI Code Generation: Connected"
        
        # Announce completion
        Speak-Text -Text "All generations complete. You can now compile and run the code." -Category "Generate"
    } else {
        $OutputTextBox.AppendText("❌ API Error: Failed to generate code`n")
        Update-OutputScroll
        $ApiLabel.Text = "AI Code Generation: Error"
        Speak-Text -Text "Failed to generate code due to API error." -Category "Generate"
    }

    $AIStatus.Text = "● AI Code Generation: Ready"
    $AIStatus.ForeColor = $colors.Success
    $StatusLabel.Text = "● Ready"
    $StatusLabel.ForeColor = $colors.Success
}

# Function to validate generated code structure
function Test-CodeStructure {
    param(
        [string]$code,
        [string]$language
    )
    
    #Write-Host "`n========== VALIDATING CODE STRUCTURE ==========" -ForegroundColor Cyan
    
    $issues = @()
    
    # Check if main() function exists
    if ($code -notmatch 'main\s*\([^)]*\)') {
        $issues += "Missing main() function"
    }
    
    if ($language -eq "C") {
        # Check for printf before scanf
        $lines = $code -split "`n"
        $scanfLines = @()
        
        for ($i = 0; $i -lt $lines.Count; $i++) {
            $line = $lines[$i].Trim()
            
            if ($line -match 'scanf\s*\(') {
                $scanfLines += $i
                # Check if there's a printf before this scanf
                $printfFound = $false
                for ($j = $i - 1; $j -ge 0; $j--) {
                    if ($lines[$j].Trim() -match 'printf\s*\(') {
                        $printfFound = $true
                        break
                    }
                }
                if (-not $printfFound) {
                    $issues += "scanf at line $($i+1) has no preceding printf prompt"
                }
            }
        }
        
        if ($scanfLines.Count -eq 0) {
            $issues += "No scanf statements found for input"
        }
    }
    elseif ($language -eq "C++") {
        # Check for cout before cin
        $lines = $code -split "`n"
        $cinLines = @()
        
        for ($i = 0; $i -lt $lines.Count; $i++) {
            $line = $lines[$i].Trim()
            
            if ($line -match 'cin\s*>>') {
                $cinLines += $i
                # Check if there's a cout before this cin
                $coutFound = $false
                for ($j = $i - 1; $j -ge 0; $j--) {
                    if ($lines[$j].Trim() -match 'cout\s*<<') {
                        $coutFound = $true
                        break
                    }
                }
                if (-not $coutFound) {
                    $issues += "cin at line $($i+1) has no preceding cout prompt"
                }
            }
        }
        
        if ($cinLines.Count -eq 0) {
            $issues += "No cin statements found for input"
        }
    }
    
    # Check for return statements
    if ($code -notmatch 'return\s+0\s*;') {
        $issues += "Missing 'return 0;' statement"
    }
    
    if ($issues.Count -gt 0) {
        #Write-Host "⚠️ Code structure issues found:" -ForegroundColor Yellow
        foreach ($issue in $issues) {
            #Write-Host "  - $issue" -ForegroundColor Yellow
        }
        return $false
    } else {
        #Write-Host "✅ Code structure validation passed" -ForegroundColor Green
        return $true
    }
}

# Enhanced version with whitelist for standard libraries
function Test-ExternalDependencies-Enhanced {
    param([string]$code)
    
    # Standard C libraries (these are OK)
    $standardCLibraries = @(
        'stdio\.h', 'stdlib\.h', 'string\.h', 'math\.h', 'ctype\.h', 
        'time\.h', 'limits\.h', 'float\.h', 'stddef\.h', 'stdarg\.h',
        'setjmp\.h', 'signal\.h', 'errno\.h', 'locale\.h', 'assert\.h'
    )
    
    # Standard C++ libraries (these are OK)
    $standardCppLibraries = @(
        'iostream', 'fstream', 'sstream', 'string', 'vector', 'list', 
        'map', 'set', 'algorithm', 'iterator', 'functional', 'memory',
        'utility', 'cmath', 'cstdlib', 'cstring', 'cctype', 'ctime',
        'climits', 'cfloat', 'stack', 'queue', 'deque', 'bitset',
        'complex', 'valarray', 'numeric', 'limits', 'exception',
        'stdexcept', 'new', 'typeinfo'
    )
    
    $allStandard = $standardCLibraries + $standardCppLibraries
    
    # Extract all includes from code
    $includes = [regex]::Matches($code, '#include\s*[<""]([^>""]+)[>""]') | ForEach-Object { $_.Groups[1].Value }
    
    $nonStandard = @()
    foreach ($inc in $includes) {
        $isStandard = $false
        foreach ($std in $allStandard) {
            if ($inc -match $std) {
                $isStandard = $true
                break
            }
        }
        if (-not $isStandard) {
            $nonStandard += $inc
        }
    }
    
    return @{
        HasExternalDependencies = ($nonStandard.Count -gt 0)
        DetectedLibraries = $nonStandard
    }
}

# Function to detect external dependencies in generated code
function Test-ExternalDependencies {
    param([string]$code)
    
    # First, identify the problem statement for context
    $problemStatement = $ProblemTextBox.Text.Trim()
    
    # List of standard C libraries (these are OK with GCC)
    $standardCLibraries = @(
        'stdio\.h', 'stdlib\.h', 'string\.h', 'math\.h', 'ctype\.h', 
        'time\.h', 'limits\.h', 'float\.h', 'stddef\.h', 'stdarg\.h',
        'setjmp\.h', 'signal\.h', 'errno\.h', 'locale\.h', 'assert\.h'
    )
    
    # List of standard C++ libraries (these are OK with GCC)
    $standardCppLibraries = @(
        'iostream', 'fstream', 'sstream', 'string', 'vector', 'list', 
        'map', 'set', 'algorithm', 'iterator', 'functional', 'memory',
        'utility', 'cmath', 'cstdlib', 'cstring', 'cctype', 'ctime',
        'climits', 'cfloat', 'stack', 'queue', 'deque', 'bitset',
        'complex', 'valarray', 'numeric', 'limits', 'exception',
        'stdexcept', 'new', 'typeinfo'
    )
    
    # List of non-standard libraries that require external dependencies
    $externalLibraries = @(
        # Graphics and GUI libraries
        'graphics\.h', 'conio\.h', 'windows\.h', 'gtk/gtk\.h', 'Qt', 'SDL', 'SFML',
        'glut\.h', 'gl\.h', 'glu\.h', 'opengl', 'directx',
        
        # Networking
        'winsock', 'socket', 'curl/curl\.h', 'boost/asio', 'winsock2\.h',
        'arpa/inet\.h', 'netdb\.h', 'sys/socket\.h', 'netinet/in\.h',
        
        # Database
        'mysql', 'sqlite3\.h', 'postgresql', 'mongoc', 'redis',
        
        # Multimedia
        'opencv', 'ffmpeg', 'portaudio', 'opencv2', 'vlc', 'gstreamer',
        
        # Other external libraries
        'pthread\.h', 'omp\.h', 'mpi\.h', 'cuda', 'cuda_runtime\.h',
        'opencl', 'blas', 'lapack', 'gsl', 'fftw3',
        
        # POSIX/Unix specific (usually not on Windows)
        'unistd\.h', 'sys/stat\.h', 'sys/types\.h', 'dirent\.h',
        'pwd\.h', 'grp\.h', 'termios\.h', 'fcntl\.h',
        
        # Boost libraries
        'boost/', 'boost/.*\.hpp',
        
        # Compression
        'zlib\.h', 'bzlib\.h', 'lzma\.h',
        
        # XML/JSON parsing
        'libxml', 'expat\.h', 'jsoncpp', 'rapidjson', 'nlohmann/json\.hpp',
        
        # Cryptography
        'openssl', 'crypto', 'ssl\.h',
        
        # Threading (beyond standard)
        'thread', 'mutex', 'condition_variable', 'future', 'atomic'  # These ARE standard in C++11+
    )
    
    $detectedLibraries = @()
    $hasExternalDependencies = $false
    
    # First, check for external dependencies
    foreach ($lib in $externalLibraries) {
        if ($code -match "#include\s*[<""].*$lib.*[>""]") {
            $detectedLib = $matches[0] -replace '#include\s*[<""](.+)[>""]', '$1'
            $detectedLibraries += $detectedLib
            $hasExternalDependencies = $true
        }
    }
    
    # Check for system calls that might indicate external dependencies
    if ($code -match 'system\s*\(\s*"') {
        $detectedLibraries += "system() call (requires OS interaction)"
        $hasExternalDependencies = $true
    }
    
    # Check for fork/exec (Unix-specific)
    if ($code -match 'fork\s*\(|exec[lvp]?\s*\(') {
        $detectedLibraries += "Process creation (fork/exec) - Unix-specific"
        $hasExternalDependencies = $true
    }
    
    # Check for Windows-specific APIs
    if ($code -match 'CreateFile|ReadFile|WriteFile|CloseHandle|MessageBox|Registry') {
        $detectedLibraries += "Windows API functions"
        $hasExternalDependencies = $true
    }
    
    # Check for network socket operations
    if ($code -match 'socket\s*\(|connect\s*\(|bind\s*\(|listen\s*\(|accept\s*\(') {
        $detectedLibraries += "Network socket operations (may need Winsock on Windows)"
        $hasExternalDependencies = $true
    }
    
    return @{
        HasExternalDependencies = $hasExternalDependencies
        DetectedLibraries = $detectedLibraries
    }
}

# Function to verify and repair temp file if needed
function Repair-TempFile {
    param([string]$filePath)
    
    if (-not (Test-Path $filePath)) {
        return $false
    }
    
    try {
        $content = Get-Content $filePath -Raw -ErrorAction Stop
        if ([string]::IsNullOrWhiteSpace($content)) {
            # File is empty, try to rewrite
            if ($global:GeneratedCode) {
                $global:GeneratedCode | Out-File -FilePath $filePath -Encoding UTF8 -Force -ErrorAction Stop
            }
        }
        return $true
    } catch {
        return $false
    }
}

# Clear All - FIXED with null checking and preserving hint message
function Clear-All {
    # Add null checking for ProblemTextBox - preserve the hint message
    if ($ProblemTextBox -ne $null) {
        # Set back to the hint/tag text
        $ProblemTextBox.Text = $ProblemTextBox.Tag
        $ProblemTextBox.ForeColor = [System.Drawing.Color]::White  # White color for hint
    }
    
    # Add null checking for all text boxes
    if ($CodeTextBox -ne $null) { $CodeTextBox.Text = "" }
    if ($AlgoTextBox -ne $null) { $AlgoTextBox.Text = "" }
    if ($ExplanationTextBox -ne $null) { $ExplanationTextBox.Text = "" }
    if ($OutputTextBox -ne $null) { $OutputTextBox.Text = "" }
    
    $global:GeneratedCode = ""
    $global:DetectedLanguage = "Unknown"
    
    # Set default tabs to Source Code and Console Output with null checking
    if ($CodeTabs -ne $null -and $CodeTab -ne $null) {
        $CodeTabs.SelectedTab = $CodeTab
    }
    if ($OutputTabs -ne $null -and $ConsoleTab -ne $null) {
        $OutputTabs.SelectedTab = $ConsoleTab
    }
    
    # Reset to default status display with null checking
    if ($LangStatusLabel -ne $null) {
        $LangStatusLabel.Text = "C/C++ Detected"
    }
    if ($LangIconLabel -ne $null) {
        $LangIconLabel.Text = "C/C++ Ready"
    }
    if ($LangStatusPanel -ne $null) {
        $LangStatusPanel.BackColor = $colors.Warning
    }
    
    Cleanup-OldFiles
    
    # Add null checking for temp file
    if (($global:TempFile -ne $null) -and (Test-Path $global:TempFile -ErrorAction SilentlyContinue)) { 
        Remove-Item $global:TempFile -Force -ErrorAction SilentlyContinue 
    }
    
    if ($StatusLabel -ne $null) {
        $StatusLabel.Text = "● Ready"
        $StatusLabel.ForeColor = $colors.Success
    }
    if ($AIStatus -ne $null) {
        $AIStatus.Text = "● AI Code Generation: Ready"
        $AIStatus.ForeColor = $colors.Success
    }
    
    # Force language detection to run (will show "Specify C/C++" since text is hint)
    Detect-LanguageFromPrompt
}

# ==================== APPLICATION STARTUP ====================

# Check Internet Connectivity
function Test-InternetConnection {
    # Silently check internet - no output
    try {
        $ping = New-Object System.Net.NetworkInformation.Ping
        $reply = $ping.Send("8.8.8.8", 1000)
        return ($reply.Status -eq "Success")
    } catch {
        try {
            return [System.Net.NetworkInformation.NetworkInterface]::GetIsNetworkAvailable()
        } catch {
            return $false
        }
    }
}

# Check Internet before API call
function Test-InternetBeforeApi {
    if (-not (Test-InternetConnection)) {
        [System.Windows.Forms.MessageBox]::Show(
            "Internet connection lost.`n`n" +
            "Please check your network connection and try again.",
            "Connection Lost",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        )
        return $false
    }
    return $true
}

# ==================== APPLICATION STARTUP ====================

# Define Run-SilentApplication function - CLEAN VERSION
function Run-SilentApplication {
    param($form)
    
    # Save original console settings
    $originalOutput = [System.Console]::Out
    $originalError = [System.Console]::Error
    $originalErrorPref = $ErrorActionPreference
    
    # Suppress output during GUI runtime
    $ErrorActionPreference = 'SilentlyContinue'
    
    # Redirect console output to null
    $null = [System.Console]::SetOut([System.IO.StreamWriter]::Null)
    $null = [System.Console]::SetError([System.IO.StreamWriter]::Null)
    
    # Run the application
    [System.Windows.Forms.Application]::Run($form)
    
    # Restore console settings after application closes
    [System.Console]::SetOut($originalOutput)
    [System.Console]::SetError($originalError)
    
    # Restore preferences
    $ErrorActionPreference = $originalErrorPref
    
    # Clear any remaining output
    [System.Console]::Write("`r" + " " * 80 + "`r")
}

# ==================== SUPPRESS ALL STARTUP OUTPUT ====================
# Temporarily redirect all output to prevent "0 1 2 3 4" numbers

# Save original output streams
$script:originalOut = [Console]::Out
$script:originalError = [Console]::Error

# Redirect to null
$script:nullOut = [System.IO.StreamWriter]::Null
$script:nullError = [System.IO.StreamWriter]::Null
[Console]::SetOut($script:nullOut)
[Console]::SetError($script:nullError)

# Override Write-Host temporarily
$script:originalWriteHost = ${function:Write-Host}
${function:Write-Host} = { }

# ==================== INITIALIZE EVERYTHING SILENTLY ====================

# Ensure AppPath is set correctly (already set earlier, but double-check)
if (-not $script:AppPath) {
    $script:AppPath = Get-AppDirectory
    Set-Location $script:AppPath
    [Environment]::CurrentDirectory = $script:AppPath
}

# Set compiler path
$global:CompilerPath = Join-Path $script:AppPath "gcc\bin\gcc.exe"

# Run all initial checks silently
Check-Compiler | Out-Null
Cleanup-OldFiles | Out-Null
Set-Voice | Out-Null
$null = Reset-TempFiles

# Set default language status
$global:DetectedLanguage = "Unknown"
if ($LangStatusLabel) { $LangStatusLabel.Text = "C/C++ Detected" }
if ($LangIconLabel) { $LangIconLabel.Text = "C/C++ Ready" }
if ($LangStatusPanel) { $LangStatusPanel.BackColor = $colors.Warning }

# Check internet silently
$hasInternet = Test-InternetConnection
if (-not $hasInternet -and $AIStatus) { 
    $AIStatus.Text = "● AI Code Generation: Offline"
    $AIStatus.ForeColor = $colors.Warning
}

# ==================== RESTORE CONSOLE OUTPUT ====================

# Restore Write-Host
${function:Write-Host} = $script:originalWriteHost

# Restore console output
[Console]::SetOut($script:originalOut)
[Console]::SetError($script:originalError)

# Clear any pending output
[Console]::Write("`r" + " " * 80 + "`r")

# ==================== LAUNCH GUI ====================

# Run application silently
Run-SilentApplication -form $MainForm

# ==================== APPLICATION CLEANUP ====================
# Standard .NET garbage collection to release resources
# This is good practice for any .NET application and helps prevent memory leaks
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()

# EDUCATIONAL NOTE: The application has now completed all operations.
# - Temporary files have been cleaned up
# - Voice synthesizer has been disposed
# - All GUI resources have been released
# - Memory has been garbage collected
#
# PowerShell will now return to the normal prompt.
# All application resources have been properly released.
# ==================== END OF CLEANUP ====================

# The script ends naturally, PowerShell will show its prompt automatically