# Pre-requisets
# Run PowerShell as Administrator.
# Run "Set-ExecutionPolicy RemoteSigned" then confirm Y
# Run the Script
# Revert the change by running "Set-ExecutionPolicy Restricted"

# VM settings
$templateVMPath = "D:\ObjectivOne\VM-Templates\Template-ObjectivOne-ParrotOS\Template-ObjectivOne-ParrotOS.vmx" # Path to the .vmx file of the template.

$newVMName = "ParrotOS-VM"
$newVMPath = "D:\ObjectivOne\VMs\$newVMName"

# Optional: Uncomment and modify the two following lines if you want to memory and CPU numbers different from the template 
# $memorySize = 4096  # Memory size in MB. Uncomment if different memory size is needed than the template one. 
# $numCPUs = 2    # Uncomment if different number of CPUs is needed than the template one. 

# VMware command-line tools path
$vmrunPath = "C:\Program Files (x86)\VMware\VMware Workstation\vmrun.exe"

# Create new VM directory
if (-Not (Test-Path $newVMPath)) {
    New-Item -Path $newVMPath -ItemType Directory
}

# Clone the template VM
$newVMXFile = "$newVMPath\$newVMName.vmx" 
& $vmrunPath clone $templateVMPath $newVMXFile full #Make a fully independent clone of the template.

# Modify the VMX configuration file if needed (optional)
# Here, you can modify the cloned .vmx file to adjust settings such as memory, CPU, VM name, & etc. if necessary
$vmxContent = Get-Content $newVMXFile

# Optional: Uncomment and modify the following two lines if you want to memory and CPU numbers different from the template 
# $vmxContent = $vmxContent -replace 'memsize = "\d+"', "memsize = `"$memorySize`""      
# $vmxContent = $vmxContent -replace 'numvcpus = "\d+"', "numvcpus = `"$numCPUs`""

# If commented the VM dsipaly name will be clone of the template name.
$vmxContent = $vmxContent -replace 'displayName = ".+"', "displayName = `"$newVMName`"" 

# Save the modified .vmx file
$vmxContent | Set-Content -Path $newVMXFile 

# Start the cloned VM
& $vmrunPath start $newVMXFile 

# Output Message
Write-Output "VM '$newVMName' created from template and started successfully."
