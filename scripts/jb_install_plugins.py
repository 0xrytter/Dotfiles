import os
import platform
import subprocess
import sys

def get_os():
    """Determine the operating system."""
    return platform.system().lower()

def find_rider_path():
    """Find the path to Rider executable in NixOS."""
    try:
        # Use 'find' command to search for Rider executable in /nix/store
        result = subprocess.run(
            ["find", "/nix/store", "-name", "rider.sh"],
            capture_output=True,
            text=True,
            check=True
        )
        paths = result.stdout.strip().split('\n')
        if paths:
            return paths[0]  # Return the first found path
    except subprocess.CalledProcessError as e:
        print(f"Error finding Rider path: {e}")
    return None

def get_ide_command(ide_name, username):
    """Determine the command for the specified JetBrains IDE."""
    if get_os() == "windows":
        ide_commands = {
            "idea": f"C:\\Users\\{username}\\.IdeaIC2024\\bin\\idea.exe installPlugins",
            "pycharm": f"C:\\Users\\{username}\\AppData\\Local\\JetBrains\\PyCharm2024\\bin\\pycharm.exe installPlugins",
            "webstorm": f"C:\\Program Files\\JetBrains\\WebStorm 2024.2.1\\bin\\webstorm64.exe installPlugins",
            "clion": f"C:\\Users\\{username}\\AppData\\Local\\JetBrains\\CLion2024\\bin\\clion.exe installPlugins",
            "phpstorm": f"C:\\Users\\{username}\\AppData\\Local\\JetBrains\\PhpStorm2024\\bin\\phpstorm.exe installPlugins",
            "rider": f"C:\\Users\\{username}\\AppData\\Local\\JetBrains\\Rider2024\\bin\\rider.exe installPlugins",
        }
    else:  # Assume Linux
        ide_commands = {
            "idea": "idea installPlugins",
            "pycharm": "pycharm installPlugins",
            "webstorm": "webstorm installPlugins",
            "clion": "clion installPlugins",
            "phpstorm": "phpstorm installPlugins",
            "rider": "rider installPlugins"
        }
        
    
    return ide_commands.get(ide_name.lower())

def install_plugins(ide_command, plugin_ids):
    """Install plugins using the specified IDE command."""
    print("Installing plugins...")
    for plugin_id in plugin_ids:
        command = f"{ide_command} {plugin_id}"
        print(f"Executing: {command}")
        try:
            subprocess.run(command, shell=True, check=True)
        except subprocess.CalledProcessError as e:
            print(f"Failed to install {plugin_id}: {e}")

def main():
    username = os.getlogin()

    ide_name = input(
        "Enter the JetBrains IDE you want to install plugins for (e.g., idea, pycharm, webstorm, etc.): "
    )
    ide_command = get_ide_command(ide_name, username)

    if not ide_command:
        print(f"Unsupported IDE: {ide_name}")
        sys.exit(1)

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

    install_plugins(ide_command, plugin_ids)

if __name__ == "__main__":
    main()
