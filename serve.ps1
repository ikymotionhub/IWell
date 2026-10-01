$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:8080/")
$listener.Start()
Write-Host "Servidor escuchando en http://localhost:8080/"
$basePath = $PSScriptRoot
if ([string]::IsNullOrEmpty($basePath)) {
    $basePath = "C:\Users\ASUS\Downloads\IWell"
}
try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        $path = $request.Url.LocalPath
        if ($path -eq "/") { $path = "/index.html" }
        
        $path = $path.Replace("/", "\")
        if ($path.StartsWith("\")) { $path = $path.Substring(1) }
        
        $file = Join-Path $basePath $path
        
        if (Test-Path $file -PathType Leaf) {
            $ext = [System.IO.Path]::GetExtension($file).ToLower()
            $mime = "application/octet-stream"
            switch ($ext) {
                ".html" { $mime = "text/html" }
                ".css"  { $mime = "text/css" }
                ".js"   { $mime = "application/javascript" }
                ".png"  { $mime = "image/png" }
                ".jpg"  { $mime = "image/jpeg" }
                ".jpeg" { $mime = "image/jpeg" }
                ".webp" { $mime = "image/webp" }
                ".svg"  { $mime = "image/svg+xml" }
            }
            $response.ContentType = $mime
            
            $content = [System.IO.File]::ReadAllBytes($file)
            $response.ContentLength64 = $content.Length
            $response.OutputStream.Write($content, 0, $content.Length)
        } else {
            $response.StatusCode = 404
            $err = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found ($file)")
            $response.ContentLength64 = $err.Length
            $response.OutputStream.Write($err, 0, $err.Length)
        }
        $response.Close()
    }
} finally {
    $listener.Stop()
}
