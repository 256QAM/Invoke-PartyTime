Function Invoke-PartyTime {
	param (
		[Parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
		 [string[]]$PartyPeople = ($Env:COMPUTERNAME),
		 [int]$HowLongToParty = -1,
		[System.Management.Automation.PSCredential]$SecretCode
	)
	
	begin {
		[scriptblock]$ScriptBlock = {
			param($time)
			Function Partayy {
				try {
					$Diskmaster = New-Object -ComObject IMAPI2.MsftDiscMaster2
					$DiskRecorder = New-Object -ComObject IMAPI2.MsftDiscRecorder2
					$DiskRecorder.InitializeDiscRecorder($DiskMaster)
					$DiskRecorder.EjectMedia()
				} catch {
					Write-Error "Failed to operate the disk. Details : $_"
				}
			}
			While (($time -Ge 1) -or ($time -eq -1)){
				Partayy
				Write-Verbose ("0: THE PARTY DONT START TILL I SNMPWALK IN")
				If ($Time -eq -1){
					$Write-Verbose ("0: WE ROWDY")
				} else {
					$time -= 1
				}
			}
		}
	}
	
	Process {
		Try {
			$PartyPeople | Foreach-Object {
				If (Test-Connection $_ -Count 1 -Quiet -ErrorAction SilentlyContinue){
					$PartyParams = @{
						ComputerName = $_ 
						ScriptBlock = $ScriptBlock
						ArgumentList = $HowLongToParty
						ErrorAction = 'SilentlyContinue'
					}
					If ($SecretCode) {                      
						$PartyParams.add("Credential", $SecretCode)            
					}  
					Invoke-Command @PartyParams
					Write-Output "$_ is going down to partytown!"
				} else {
					Write-Output '$_ is at another party :('
				}
			}
		} catch {
			Write-Output "$_ is a partypooper. Lame Excuse: "
			Write-Output $_.ExceptionMessage
		}
	}
	
	End{}
}