# This PowerShell script was generated as a mitigation by Azure DevOps TLS 1.2 transition readiness checker.
[microsoft.win32.registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework\v4.0.30319", "SchUseStrongCrypto", 1)
[microsoft.win32.registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework\v4.0.30319", "SystemDefaultTlsVersions", 1)
[microsoft.win32.registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319", "SchUseStrongCrypto", 1)
[microsoft.win32.registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319", "SystemDefaultTlsVersions", 1)
[microsoft.win32.registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework\v2.0.50727", "SchUseStrongCrypto", 1)
[microsoft.win32.registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework\v2.0.50727", "SystemDefaultTlsVersions", 1)
[microsoft.win32.registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v2.0.50727", "SchUseStrongCrypto", 1)
[microsoft.win32.registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v2.0.50727", "SystemDefaultTlsVersions", 1)
'Done!'