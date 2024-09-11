import os
import platform
import subprocess
import sys


def get_os():
    """Determine the operating system."""
    return platform.system().lower()


def get_ide_command(ide_name, username):
    """Determine the command for the specified JetBrains IDE."""
    if get_os() == "windows":
        ide_commands = {
            "idea": f"C:\\Users\\{username}\\.IdeaIC2024\\bin\\idea.exe installPlugins",
            "pycharm": f"C:\\Users\\{username}\\AppData\\Local\\JetBrains\\PyCharm2024\\bin\\pycharm.exe installPlugins",
            "webstorm": f"C:\Program Files\JetBrains\WebStorm 2024.2.1\bin\webstorm64.exe installPlugins",
            "clion": f"C:\\Users\\{username}\\AppData\\Local\\JetBrains\\CLion2024\\bin\\clion.exe installPlugins",
            "phpstorm": f"C:\\Users\\{username}\\AppData\\Local\\JetBrains\\PhpStorm2024\\bin\\phpstorm.exe installPlugins",
            "rider": f"C:\\Users\\{username}\\AppData\\Local\\JetBrains\\Rider2024\\bin\\rider.exe installPlugins",
        }
    else:  # Assume Linux
        ide_commands = {
            "idea": f"/home/{username}/.local/share/JetBrains/Toolbox/apps/idea-U/bin/idea.sh installPlugins",
            "pycharm": f"/home/{username}/.local/share/JetBrains/Toolbox/apps/pycharm-professional/bin/pycharm.sh installPlugins",
            "webstorm": f"/home/{username}/.local/share/JetBrains/Toolbox/apps/webstorm/bin/webstorm.sh installPlugins",
            "clion": f"/home/{username}/.local/share/JetBrains/Toolbox/apps/clion/bin/clion.sh installPlugins",
            "phpstorm": f"/home/{username}/.local/share/JetBrains/Toolbox/apps/phpstorm/bin/phpstorm.sh installPlugins",
            "rider": f"/home/{username}/.local/share/JetBrains/Toolbox/apps/rider/bin/rider.sh installPlugins",
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
