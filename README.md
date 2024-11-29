# DesktopChanger
Change all the files and folders on your desktop in a click.  
(only for Windows)

### Written 100% in Lua using [LuaRT](https://github.com/samyeyo/LuaRT) framework.

# How it works and how to operate the program
Windows's file system allows to create several kinds of symlinks, among which is a Junction. A Junction is a link to a folder which is indistinguishable from a real folder.  
Upon the first launch of the program, your private desktop files and folders will be moved to <user>/.desktopChanger/Default. Then the real desktop folder is deleted entirely (requires killing explorer, that's why you'll see the screen go black, do not panic) and replaced with a Junction link to the Default folder. Since Windows doesn't differentiate between a Junction and a real folder, no program functionality will be lost, and your desktop will be visually unchanged. But now, since it's simply a link, we can freely delete and dynamically change it.  
Now, we can create more desktops! Open the "Add desktops" tab, enter the new desktop name, and then either press "Create a new desktop" for an empty desktop, or press "Link an existing folder" to create yet another Junction to a folder of your choice. (A Junction to an another Junction works as expected, somehow!)  
Switch back to the "Set desktop" tab. Here, you can find a list of the desktops you've created. Selecting a desktop and pressing switch will delete the existing link and add another one to the folder of your choice.  
#### It is important that you remember to press F5 afterwards to refresh the explorer.
Other buttons include:
- "Open in explorer": open an explorer.exe to the chosen folder.
- "Refresh": refreshes the desktop list in case that you changed the folders manually.
- "Delete desktop": deletes the folder. If it is not empty, it will prompt you to delete all files.
- "Move to tray": closes the window and moves the program to tray (the ^ symbol next to your clock). There you can left-click to open the window again, or right-click to have the main functionality without opening the window.
