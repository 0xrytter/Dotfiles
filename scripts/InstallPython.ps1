# Function to check and install Python on Windows
function Install-Python {
    Write-Host "Checking for Python installation on Windows..."
    $pythonPath = "C:\Python39" # Adjust this path based on your installation
    if (Test-Path -Path $pythonPath) {
        Write-Host "Python is already installed."
    } else {
        Write-Host "Downloading Python installer..."
        $installerUrl = "https://www.python.org/ftp/python/3.9.0/python-3.9.0-amd64.exe"
        $installerPath = "$env:TEMP\python-installer.exe"
        Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath

        Write-Host "Installing Python..."
        Start-Process -FilePath $installerPath -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1" -Wait
    }
}

# Detect operating system
if ($env:OS -eq "Windows_NT") {
    Install-Python
} else {
    Write-Host "Unsupported operating system."
}
