# Script: scom_check.ps1
# Description: This script checks the status of the SCOM service on a remote server and performs troubleshooting steps if needed.

# Define the server name (you can also take this as an input parameter)
$server = "YourServerName"
$ticketNumber = "YourTicketNumber"

# Function to log messages
function Log-Message {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "$timestamp - $message"
}

# Function to update worknotes
function Update-Worknotes {
    param (
        [string]$note
    )
    # Placeholder for updating worknotes, e.g., updating a ticket system
    Log-Message "Worknote updated: $note"
}

# Check if the server is reachable
Log-Message "Pinging $server..."
if (Test-Connection -ComputerName $server -Count 2 -Quiet) {
    Log-Message "$server is reachable."
    
    # Check if we can connect via RDP
    Log-Message "Attempting to connect to $server via RDP..."
    try {
        Enter-PSSession -ComputerName $server -Credential (Get-Credential)
        Log-Message "Connected to $server via RDP."

        # Check the status of the Microsoft Monitoring Agent service
        $serviceName = "HealthService"
        $service = Get-Service -ComputerName $server -Name $serviceName
        
        if ($service.Status -eq "Running") {
            Log-Message "The 'Microsoft Monitoring Agent' service is running on $server."
            Update-Worknotes "Ticket $ticketNumber: The 'Microsoft Monitoring Agent' service is running. Closing the ticket."
        } else {
            Log-Message "The 'Microsoft Monitoring Agent' service is not running on $server. Attempting to start it..."
            Start-Service -ComputerName $server -Name $serviceName
            Start-Sleep -Seconds 10  # Wait for the service to start
            $service = Get-Service -ComputerName $server -Name $serviceName
            
            if ($service.Status -eq "Running") {
                Log-Message "The 'Microsoft Monitoring Agent' service started successfully on $server."
                Update-Worknotes "Ticket $ticketNumber: The 'Microsoft Monitoring Agent' service was not running but has been started. Closing the ticket."
            } else {
                Log-Message "Failed to start the 'Microsoft Monitoring Agent' service on $server. Assigning to Windows team."
                Update-Worknotes "Ticket $ticketNumber: The 'Microsoft Monitoring Agent' service is down and could not be started. Assigning to Windows team."
            }
        }
        
        Exit-PSSession
    } catch {
        Log-Message "Failed to connect to $server via RDP. Assigning to Windows team."
        Update-Worknotes "Ticket $ticketNumber: Failed to connect to $server via RDP. Assigning to Windows team."
    }
} else {
    Log-Message "$server is not reachable. Assigning to Windows team."
    Update-Worknotes "Ticket $ticketNumber: $server is not reachable. Assigning to Windows team."
}

Log-Message "Script execution completed."
