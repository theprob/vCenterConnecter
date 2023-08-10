#
#	PowerShell Script which helps to connect vCenter servers via PowerCLI.
#	You can connect mulitple servers through the console, every connection will open in a new window.
#	You only need to type your password, the server and usernames are stored in a .json file,
#	calles 'environments.json', which should be kept in the same folder as the script itself.
#	Passwords are not stored! Credentials are handled with the native credential manager of windows.
#
#	How2Use:
#		1.	Run the "vCenterConnecter.ps1" script
#		2.	If you start it 1st, you will got a notification about missing profile.
#			Choose "yes", and the script will make a personal copy from the "environments.json" file
#			to your documents folder. (C:\users\<username>\documents\vCenterConnecter)
#		3.	You should modify that file (which was created on step 2) based on your preferences.
#			There are 5 sample entries. Username change is mandatory!
#		4.	You can remove existing or add further entries if you wish, just keep in my the syntax
#			of the .json file.
#		5.	You can create a shortcut to your desktop with the 'S' command, if you'd like.
#