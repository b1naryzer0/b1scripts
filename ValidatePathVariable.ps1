 ($env:path).Split(";") | % { "$(Test-Path $_): $_ "  }
