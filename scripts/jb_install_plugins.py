import os
import platform
import subprocess
import getpass

def get_os():
    """Determine the operating system."""
    return platform.system().lower()

def check_ide_installed(ide_command):
    """Check if an IDE is installed by running its version command."""
    try:
        result = subprocess.run(ide_command.split() + ['--version'], capture_output=True, text=True)
        return result.returncode == 0  # Return True if the command succeeded
    except Exception as e:
        print(f"Error checking {ide_command}: {e}")
        return False

def get_ide_command(ide_name, username):
    """Determine the command for the specified JetBrains IDE."""
    if get_os() == "windows":
        ide_commands = {
            "idea": f"C:\\Users\\{username}\\.IdeaIC2024\\bin\\idea.exe",
            "pycharm": f"C:\\Users\\{username}\\AppData\\Local\\JetBrains\\PyCharm2024\\bin\\pycharm.exe",
            "webstorm": "C:\\Program Files\\JetBrains\\WebStorm 2024.2.1\\bin\\webstorm64.exe",
            "clion": f"C:\\Users\\{username}\\AppData\\Local\\JetBrains\\CLion2024\\bin\\clion.exe",
            "phpstorm": f"C:\\Users\\{username}\\AppData\\Local\\JetBrains\\PhpStorm2024\\bin\\phpstorm.exe",
            "rider": f"C:\\Users\\{username}\\AppData\\Local\\JetBrains\\Rider2024\\bin\\rider.exe"
        }
    else:  # Assume Linux
        ide_commands = {
            "idea": "idea",
            "pycharm": "pycharm",
            "webstorm": "webstorm",
            "clion": "clion",
            "phpstorm": "phpstorm",
            "rider": "rider"
        }
    
    return ide_commands.get(ide_name.lower())

def install_plugins(ide_command, plugin_ids):
    """Install plugins using the specified IDE command."""
    print("Installing plugins...")
    for plugin_id in plugin_ids:
        command = f"{ide_command} installPlugins {plugin_id}"
        print(f"Executing: {command}")
        try:
            subprocess.run(command, shell=True, check=True)
        except subprocess.CalledProcessError as e:
            print(f"Failed to install {plugin_id}: {e}")

def main():
    username = getpass.getuser()
    
    # List of all possible JetBrains IDEs
    ide_names = ["idea", "pycharm", "webstorm", "clion", "phpstorm", "rider"]
    
    # Check which IDEs are installed
    installed_ides = []
    for ide_name in ide_names:
        ide_command = get_ide_command(ide_name, username)
        if ide_command and check_ide_installed(ide_command):
            installed_ides.append(ide_name)

    if not installed_ides:
        print("No installed JetBrains IDEs found.")
        return

    plugin_ids = [
        "AceJump",
        "org.jetbrains.action-tracker",
        "com.github.catppuccin.jetbrains",
        "ca.alexgirard.HarpoonIJ",
        "IdeaVIM",
        "org.jetbrains.IdeaVim-EasyMotion",
        "com.joshestein.ideavim-quickscope",
        "io.github.mishkun.ideavimsneak",
        "youngstead.relative-line-numbers",
        "Scratch",
        "eu.theblob42.idea.whichkey",
    ]

    # Install plugins for each installed IDE
    for ide_name in installed_ides:
        ide_command = get_ide_command(ide_name, username)
        install_plugins(ide_command, plugin_ids)

if __name__ == "__main__":
    main()
