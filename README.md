# vCenter Connecter

PowerShell Script which helps to connect vCenter servers via PowerCLI.
The script generates a TUI (Text-based user interface) in runtime, on a .json.
ELM (Enhanced Linked Mode) is supported, to define such environments list every vCenter server for the "Servers" key's value. (as you can see in the example under "Env2") 
You only need to type your password, the servers and usernames are stored in a .json file,
called 'environments.json', which should be kept in the same folder as the script itself.
Passwords are not stored! Credentials are handled with the native credential manager of windows.

## Screenshot:
![image](https://github.com/theprob/vCenterConnecter/assets/9071071/20d6b7d2-0310-4076-bf27-50045406b1f8)

## How2Use:

 1. Run the "**vCenterConnecter.ps1**" script
 2. If you start it 1st, you will got a notification about missing profile.
	Choose "yes", and the script will make a personal copy from the "**environments.json**" file
	to your documents folder. (**C:\users\\\<username>\documents\vCenterConnecter**).
 3. You should modify that file (which was created on step 2) based on your preferences.
	There are 5 sample entries. Username change is mandatory!
 4. You can remove existing or add further entries if you wish, just keep in my the syntax
	of the .json file.
 5. You can create a shortcut to your desktop with the '**S**' command, if you'd like.
