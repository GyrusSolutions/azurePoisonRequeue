# azurePoisonRequeue
A very simple PowerShell script to re-queue messages from -poison

Don't forget to `Select-AzSubscription` before runnint the script.

Parameters:
1. `accountName` - pattern, `-like` matching.
2. `queueName` - name of the queue to return messages to.

Example:

`.\reQeueu.ps1 "somestorage*" queue1`

This would move messages from queue1-poison to queue1 in all storage accounts that match somestorage* pattern.
