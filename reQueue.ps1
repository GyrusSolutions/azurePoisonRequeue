param(
[Parameter(Position=0,Mandatory=$true)] $accountName,
[Parameter(Position=1,Mandatory=$true)] $queueName
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$accList = Get-AzStorageAccount | Where-Object { $_.StorageAccountName -like $accountName }

$accList | foreach {

	Write-Host "Account" $_.StorageAccountName

	$queue = $null
	try { $queue = Get-AzStorageQueue –Name $queueName –Context $_.Context } catch {}

	if($queue) {

		Write-Host $queue.Name found.

		$queuePoison = $null
		try { $queuePoison = Get-AzStorageQueue –Name "${queueName}-poison" –Context $_.Context } catch {}

		if($queuePoison){

			Write-Host $queuePoison.Name exists.

			$msg = $queuePoison.CloudQueue.GetMessage($null,$null,$null)
			while($msg){

				Write-Host Message $msg.Id $msg.AsString
				$popReceipt = $msg.PopReceipt
				$id = $msg.Id

				$queue.CloudQueue.AddMessage($msg)
				$queuePoison.CloudQueue.DeleteMessage($id, $popReceipt)

				$msg = $queuePoison.CloudQueue.GetMessage($null,$null,$null)
			}

		} else {
			Write-Host Poison queue not found, skipping.
		}
	}
}
