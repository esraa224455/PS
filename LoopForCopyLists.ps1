
#Parameters
$SourceSiteURL = "https://t6syv.sharepoint.com/sites/EsraaTeamSite"
$DestinationSiteURL = "https://t6syv.sharepoint.com/sites/TargetSite"
  
#Connect to the source Site
Connect-PnPOnline -URL $SourceSiteURL -UseWebLogin
  
#Get all document libraries
$SourceLists =  Get-PnPList -Includes RootFolder | Where {$_.BaseType -eq "GenericList" -and $_.Hidden -eq $False} | Select Title, Description, ItemCount
#Connect to the destination site
Connect-PnPOnline -URL $DestinationSiteURL -UseWebLogin
  
#Get All Lists in the Destination site
$DestinationLists = Get-PnPList
  
ForEach($SourceList in $SourceLists)
{
    #Check if the library already exists in target
    If(!($DestinationLists.Title -contains $DestinationLists.Title))
    {
        #Create a document library
        $NewList  = New-PnPList -Title $SourceList.Title -Template GenericList
        Write-host "Document List '$($SourceList.Title)' created successfully!" -f Green
        $listItems = Get-PnPListItem -List $SourceList -Fields "Id","Title","Guid"
         foreach($item in $listItems) {
           $itemVal = @{
            'Title' = $item['Title']
           }
          Add-PnPListItem -List $NewList -Values $itemVal -ContentType "Item"
        }
    }
    else
    {
        Write-host "Document List '$($SourceList.Title)' already exists!" -f Yellow
    }
  
    #Get the Destination Library
    $DestinationList = Get-PnPList $SourceList.Title -Includes RootFolder
    $SourceListURL = $SourceList.RootFolder.ServerRelativeUrl
    $DestinationListURL = $DestinationList.RootFolder.ServerRelativeUrl
  
    #Copy All Content from Source Library to Destination library
    Copy-PnPFile -SourceUrl $SourceListURL -TargetUrl $DestinationListURL -SkipSourceFolderName -Force -OverwriteIfAlreadyExists
    Write-host "`tContent Copied from $SourceListURL to  $DestinationListURL Successfully!" -f Green
}