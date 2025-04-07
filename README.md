# GTA V Network Controller

A lightweight AutoHotkey script for managing GTA V network connections, allowing you to block/unblock network access and control the save system with customizable hotkeys and a convenient system tray menu.

![GitHub License](https://img.shields.io/github/license/mishl-dev/gtav-network-hotkeys)
![AutoHotkey Version](https://img.shields.io/badge/AutoHotkey-v2.0-blue)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey)

## Features

- **Network Control**: Quickly block or unblock GTA V's network access
- **Save Control**: Toggle saving functionality on/off
- **Easy Access**: Control via hotkeys or system tray menu
- **Status Monitoring**: Check current status of network and save blocking
- **Auto-Cleanup**: Automatically removes firewall rules when the script exits

## Requirements

- Windows 10/11
- [AutoHotkey v2.0](https://www.autohotkey.com/) or newer
- Administrator privileges (required for firewall rule management)

## Installation

1. Install [AutoHotkey v2.0](https://www.autohotkey.com/download/) if you don't have it already
2. Download the latest release from the [Releases page](https://github.com/mishl-dev/gtav-network-hotkeys/releases)
3. Extract the files to a location of your choice
4. Run the script by double-clicking the `.ahk` file

## Usage

### Hotkeys

| Action | Hotkey | Alternative |
|--------|--------|-------------|
| Block network | Ctrl+Numpad0 | Ctrl+F5 |
| Unblock network | Ctrl+Numpad1 | Ctrl+F6 |
| Disable saving | Ctrl+F9 | - |
| Enable saving | Ctrl+F12 | - |
| Show help | Ctrl+F8 | Ctrl+H |
| Exit application | Alt+Shift+F4 | - |

### System Tray Menu

Right-click the script icon in the system tray to access all functions:

- **Network Controls**
  - Block Network
  - Unblock Network
- **Saving Controls**
  - Disable Saving
  - Enable Saving
- **Show Help**: Display all available commands
- **Check Status**: View current status of network and save blocking
- **Exit**: Close the application

## How It Works

The script uses Windows Firewall rules to:

1. **Network Blocking**: Creates firewall rules that block GTA V's incoming and outgoing network traffic
2. **Save Blocking**: Blocks connections to Rockstar's save servers (IP: 192.81.241.171)

All rules are automatically removed when the script is closed.

## Troubleshooting

- **Script doesn't work**: Make sure you're running as administrator
- **Firewall rules not created**: Check Windows Defender Firewall settings
- **GTA V path not detected**: Manually edit the script to add your installation path

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Disclaimer

This software is provided for educational purposes only. Use at your own risk. The authors are not responsible for any consequences of using this software.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Credits

- Created by [mishl-dev](https://github.com/mishl-dev)

---

*This tool is not affiliated with or endorsed by Rockstar Games or Take-Two Interactive.*
