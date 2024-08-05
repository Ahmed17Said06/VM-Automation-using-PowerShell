# Pre-requisets
# Run PowerShell as Administrator.
# Run "Set-ExecutionPolicy RemoteSigned" then confirm Y
# Run the Script
# Revert the change by running "Set-ExecutionPolicy Restricted"

# VM settings
$templateVMPath = "D:\ObjectivOne\VM-Templates\Template-ObjectiveOne-ParrotOS\Template-ObjectiveOne-ParrotOS.vmx" # Path to the .vmx file of the template.
$newVMName = "test-VM"
$newVMPath = "D:\ObjectivOne\VMs\$newVMName"
$sharedFolderPath = "D:\ObjectivOne\Projects\Project2\shared"


# Optional: Uncomment and modify the two following lines if you want to memory and CPU numbers different from the template 
# $memorySize = 4096  # Memory size in MB. Uncomment if different memory size is needed than the template one. 
# $numCPUs = 2    # Uncomment if different number of CPUs is needed than the template one. 

# VMware command-line tools path
$vmrunPath = "C:\Program Files (x86)\VMware\VMware Workstation\vmrun.exe"

# Check if template VM exists
if (-Not (Test-Path $templateVMPath)) {
    Write-Output "Error: Template VM not found at path: $templateVMPath"
    exit 1
}

# Create new VM directory
if (-Not (Test-Path $newVMPath)) {
    New-Item -Path $newVMPath -ItemType Directory
}

# Clone the template VM
$newVMXFile = "$newVMPath\$newVMName.vmx"
Write-Output "Cloning template VM..."
& $vmrunPath clone $templateVMPath $newVMXFile full #Make a fully independent clone of the template.

# Check if the new VMX file was created
if (-Not (Test-Path $newVMXFile)) {
    Write-Output "Error: Failed to create new VMX file at path: $newVMXFile"
    exit 1
}

# Modify the VMX configuration file if needed (optional)
# Here, you can modify the cloned .vmx file to adjust settings such as memory, CPU, VM name, & etc. if necessary
Write-Output "Modifying VMX configuration file..."
$vmxContent = Get-Content $newVMXFile

# Optional: Uncomment and modify the following two lines if you want to memory and CPU numbers different from the template 
# $vmxContent = $vmxContent -replace 'memsize = "\d+"', "memsize = `"$memorySize`""      
# $vmxContent = $vmxContent -replace 'numvcpus = "\d+"', "numvcpus = `"$numCPUs`""

# If commented the VM dsipaly name will be clone of the template name.
$vmxContent = $vmxContent -replace 'displayName = ".+"', "displayName = `"$newVMName`"" 
$vmxContent = $vmxContent -replace 'sharedFolder0.hostPath = ".+"', "sharedFolder0.hostPath = `"$sharedFolderPath`""
$vmxContent = $vmxContent -replace 'isolation.tools.hgfs.disable = ".+"', "isolation.tools.hgfs.disable = `"FALSE`""

# Ensure the shared folder directory exists on the host
if (-Not (Test-Path $sharedFolderPath)) {
    New-Item -Path $sharedFolderPath -ItemType Directory
}

# Save the modified .vmx file
$vmxContent | Set-Content -Path $newVMXFile 

# Start the cloned VM
& $vmrunPath start $newVMXFile 

# Output Message
Write-Output "VM '$newVMName' created from template and started successfully."