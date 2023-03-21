$SiteURL="https://t6syv.sharepoint.com/sites/esraateamsite"
$UserName="AlexW@t6syv.onmicrosoft.com"
$Password = "Esraa#12345"
$SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $UserName, $SecurePassword
Connect-PnPOnline -Url $SiteURL -Credentials $Cred

Get-PnPListItem -List 'Fruits'

New-PnPList -Title "SList" -Template GenericList

$listItems = Get-PnPListItem -List 'Fruits' -Fields "Id","Title","Guid"
 foreach($item in $listItems) {
   $itemVal = @{
    'Title' = $item['Title']
   }
  Add-PnPListItem -List 'SList' -Values $itemVal -ContentType "Item"
}