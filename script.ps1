param (
    [string]$folder_name 
)

$base_folder = "C:\Users\bahayman\Documents\Scripts"
$ol = New-Object -comObject Outlook.Application
$mail = $ol.CreateItem(0)
$mail.To = ""
$mail.Subject = ""
$mail.BodyFormat =  3

$cssStyles = @"
<style>
    table, th, td {
    border: solid 1px #000;
    padding: 10px;
    }

    table {
        border-collapse:collapse;
        caption-side:bottom;
    }

    caption {
    font-size: 16px;
    font-weight: bold;
    padding-top: 5px;
    }
</style>
"@

$images_folder = "$base_folder\captures\$folder_name"
$markdowns_folder = "$base_folder\markdowns\$folder_name"
# Temp file to write the content of the python script
$outputFile = New-TemporaryFile
$signatureFile = New-TemporaryFile

$files = Get-ChildItem -Path $markdowns_folder -File

foreach ($file in $files) {
    $markdown_file = $file.Name
}

# Get the result of the python Script
# -NoNewWindow to not open a new window
Start-Process -FilePath python -ArgumentList ".\mark-to-html.py", "$markdowns_folder\$markdown_file", $images_folder  -Wait -NoNewWindow -RedirectStandardOutput $outputFile.FullName

# Get the content of the temp file - Set the encoding to UTF-8
$html_body = Get-Content -Path $outputFile.FullName -Encoding UTF8


# Signature
Start-Process -FilePath python -ArgumentList ".\imgbase64.py", "C:\Users\bahayman\Documents\Scripts\signatures", "C:\Users\bahayman\Documents\Scripts\signatures\signature.html"  -Wait -NoNewWindow -RedirectStandardOutput $signatureFile.FullName

$signature = Get-Content -Path $signatureFile.FullName -Encoding UTF8

# Write-Host $signature

# Clean up the temp files / __pycahce__
Remove-Item -Path $outputFile.FullName
Remove-Item -Path $signatureFile.FullName
if (Test-Path -Path ".\__pycache__") {
    Remove-Item -Path ".\__pycache__" -Recurse
}

$template = @"
$cssStyles
<p>Bonjour,</p>
$html_body
<br>
Cordialement,
<br>
<br>
<footer>$signature</footer>
"@

$mail.HTMLBody = $template

#Open the mail in preview
$mail.SentOnBehalfOfName = ""

Write-Host "Email oppened in preview mode ! " -ForegroundColor Green

$mail.Display()
#$mail.Send()






