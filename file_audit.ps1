#WANT TO DO:
# 1. Extract all files in subfolders and put into .csv so that other people can easily look at it
# 2. Determine what "essential" files are missing from these archives:
# i.e Contract, Direct Debit Form, etc.

#WORKING CODE
#Count objects in top folder
$toRemove = (Get-ChildItem "FILEPATH" -File | Measure-Object).Count

$d = Get-ChildItem -Path "FILEPATH" -Recurse

#Get all files as list
$documents = New-Object Collections.Generic.List[string]
foreach ($item in $d) {
	if ($item.Mode -eq "-a----") {
		$documents.Add($item.FullName)
	}
}

#Remove files in top folder
$documents = $documents[$toRemove..($documents.Length[-1])]

#Kind of working code
#Extract details from file path
$allDocs = @()
$results = @()
foreach ($document in $documents){
	$location = $document.split('\')[-4].split('-')[0]
	$unit = $document.split('\')[-3] -replace 'ILU'
	$date = $document.split('\')[-1].split('.')[0].split($Name, $Name.length+2)[0]
	$Name = $document.split('\')[-2]
	$doc = $document.split('\')[-1].split('.')[0].split($Name, $Name.length+2)[-1].Trim()
	$results = [PSCustomObject]@{
		"Name"=$Name; 
		"Location"=$location;
		"Unit"=$unit;
		"Date"=$date;
		"Document"=$doc}
$allDocs += $results
}

#Maybe...
$allDocs | Export-Csv -Path "FILEPATH" -NoTypeInformation
