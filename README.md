# O2-Sec
## This is a PowerShell script to automate the creation of a VM with VMware Workstation Pro.
#### - First you need to create a Template or use the .vmx file on this repo as a template
#### - Then supply the .vmx template to the PowerShell script
#### - Finally run the script

## Template Creation on VMware Workstation Pro.
#### - After Creating the original instance of the VM. 
#### - Go to advanced options & select "Enable Template Mode"
#### - Take a SnapShot from the VM (must be turned off)
#### - Right click the VM >> manage >> clone >> an existing snapshot >> select the snapshot name
#### - Follow the flow
#### - This clone is the template the script will use to create VM instances

## Running the script (Tested On Windows 11)
#### - Run PowerShell as Administrator.
#### - Run "Set-ExecutionPolicy RemoteSigned" & confirm Y
#### - Make sure to supply the .vmx path of the template and adjust the path of the new VM as you wish
#### - Run the script (Can be run without Administrator privilege)
#### - Revert the change made in the PowerShell by running "Set-ExecutionPolicy Restricted" as admin and confirm Y

## Inside the VM
#### - Login with password: 1234
#### - Run the following command as sudo to enable the shared folder "sudo vmhgfs-fuse .host:/shared /mnt/hgfs/shared -o allow_other -o uid=1000"

