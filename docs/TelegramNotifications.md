# Telegram Norifications

### Use next instruction to create Telegram Bot that will notify you when your computer is started.

**Create Telegram Bot and get access token**
  1. Open [@BotFather](https://telegram.me/BotFather) and create `/newbot`
  2. Write `/token` to get access token
  
  **Get your Telegram/Chat ID**
  1. Open [@my_id_bot](https://t.me/my_id_bot) and `/start`

  **Script setup**
  1. Install last vesion of [Anywakey](https://apps.apple.com/us/app/anywakey/id6502517855)
  2. Open **Anywakey** app
  3. Press `menu` icon at the top left corner -> ![list dash](https://github.com/user-attachments/assets/bd736b65-0796-4e8e-a87e-3fae908ed53d)
  4. Press `Telegram notifications` -> ![paperplane circle fill](https://github.com/user-attachments/assets/5fde6b82-bd61-49bc-a8e0-9fcff77a4b8a)
  5. Insert `token` from  [@BotFather](https://telegram.me/BotFather) into `Token` textfield
  6. Insert `Telegram ID` from [@my_id_bot](https://t.me/my_id_bot) into `Telegram ID` textfield
  7. Insert `notification message`  into `Message` textfield
  8. Choose `System type` - Windows | MacOS | Linux
  9. Press `Export configuration file` button -> ![doc text fill](https://github.com/user-attachments/assets/ba2377f0-0758-4050-a9e4-7fe9473932c8)
  10. Put `notifier` file into target computer

### Example screenshot
<img src="https://github.com/user-attachments/assets/327f87fa-3695-447a-9535-0d7b6f7f1c74" alt="screen" width="400"/>

# Windows setup
### Add an script to run automatically at startup
1. Press the `Windows + R`, type `shell:startup`, then select `OK`. This opens the `Startup folder`
2. Copy and paste the `notifier.bat` to the `Startup folder`
3. Reboot your computer and check your Telegram Bot

# MacOS setup
### Add an app to run automatically at startup
1. Copy and paste the `notifier.sh` to the `target derictory`
2. Open `Terminal` in the `target derictory`
3. Run command to allow execute script
  ```
  chmod +x ./notifier.sh
  ```
4. Run command to remove scritp from apple quarantine
  ```
  xattr -d com.apple.quarantine ./notifier.sh
  ```
5. Then set a crontab for it
  ```
  
  ```
 Reboot your computer, login and check your Telegram Bot








