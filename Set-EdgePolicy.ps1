Import-Module "$PSScriptRoot\Modules\InstallTools.psm1"

# Apply Edge policies
# Set-EdgePolicies -Scope "HKCU"
Set-EdgePolicies -Scope "HKLM"
