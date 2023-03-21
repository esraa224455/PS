Clear-Host
$SourceSiteURL="https://t6syv.sharepoint.com/sites/esraateamsite"
$DestinationSiteURL="https://t6syv.sharepoint.com/sites/TargetSite"
$UserName="AlexW@t6syv.onmicrosoft.com"
$Password = "Esraa#12345"
$SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $UserName, $SecurePassword
$SourceConn = Connect-PnPOnline -Url $SourceSiteURL -Credentials $Cred
$DestinationConn = Connect-PnPOnline -Url $DestinationSiteURL -Credentials $Cred

 
$SourceLists =  Get-PnPList -Connection $SourceConn 


$DestinationLists = Get-PnPList -Connection $DestinationConn
  
ForEach($SourceList in $SourceLists)
{
 
    If(!($DestinationLists.Title -contains $DestinationLists.Title))
    {
        $ListTitle = $SourceList.Title 
        Remove-PnPList -Identity $ListTitle  -Force
        $NewList  = New-PnPList -Title $SourceList.Title -Template GenericList
        Write-host "Document List '$($SourceList.Title)' created successfully!" -f Green
        $listItems = Get-PnPListItem -List $SourceLists -Fields "Id","Title","Guid"
         foreach($item in $listItems) {
           $itemVal = @{
            'Title' = $item['Title']
           }
          Add-PnPListItem -identity $NewList -Values $itemVal -ContentType "Item"
        }
    }
    else
    {
        $ListTitle = $SourceList.Title 
        Remove-PnPList -Identity $ListTitle  -Force
        Write-host "Document List '$($SourceList.Title)' already exists!" -f Yellow
    }
    
    #Copy-PnPList -SourceListUrl $SourceSiteURL -Verbose -DestinationWebUrl $DestinationSiteURL 
 
}