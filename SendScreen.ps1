
function LocateImage($image_directory)
{
    $attachment = ""

    Get-ChildItem -Force -Recurse -Path $image_directory | Foreach-Object {
                                                                                $file = $_ 
                                                                                $extension = [IO.Path]::GetExtension($file)
                                                                                if($extension -eq '.jpg')
                                                                                {
                                                                                    $attachment = $_.FullName
                                                                                }
                                                                          }
    return $attachment
}

function TakeScreenShot()
{

    [Reflection.Assembly]::LoadWithPartialName("System.Drawing")
    function screenshot([Drawing.Rectangle]$bounds, $path) 
    {
        $bmp = New-Object Drawing.Bitmap $bounds.width, $bounds.height
        $graphics = [Drawing.Graphics]::FromImage($bmp)

        $graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)

        $bmp.Save($path)

        $graphics.Dispose()
        $bmp.Dispose()
    }

    $bounds = [Drawing.Rectangle]::FromLTRB(0, 0, 1000, 900)
    $dateTime = Get-Date -Format "MM_dd_yyyy_hh_mm_ss"
    $imageTitle = "temperature_reading_"+$dateTime+"_.jpg"

    screenshot $bounds "C:\Users\FAIS.TIER2.GAINES\Desktop\TempMonitor\$imageTitle"

    $imagePath = "C:\Users\FAIS.TIER2.GAINES\Desktop\TempMonitor\$imageTitle"

    return $imagePath
}

function SendImage($imagePath)
{
    $verifyImage = Test-Path $imagePath
    
    if($verifyImage)
    {
        Write-Host -ForegroundColor Green "[*] Located the screen shot at: $imagePath "

        $recipients = @('<email.addr>','<email.addr>','<email.addr>','<email.addr>')

        $recipients | Foreach-Object {
                                        $dateTime = Get-Date
                                        $recipient = $_
                                        Send-MailMessage -To $recipient -From 'freezer.farm@wsu.edu' -Subject "Temperature Reading $dateTime" -Body "Temperature Reading - $dateTime" -Attachments $attachment -SmtpServer "smtp.server.addr" -Port 25 -UseSsl:$false
                                        Write-Host -ForegroundColor Green "[*] Sent message to: $recipient"
                                     }
        Remove-Item $imagePath
    }
    else
    {
        Write-Host -ForegroundColor Red "[*] Failed to locate the screen shot at: $imagePath "
        return
    }
}

while(1)
{
    $imagePath = TakeScreenShot

    $attachment = LocateImage $imagePath

    SendImage $attachment

    Write-Host -ForegroundColor Green "[~] Waiting "

    Start-Sleep -Seconds 3600
}


