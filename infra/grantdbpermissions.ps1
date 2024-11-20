$groupid = '8bc63838-3556-48fd-98b8-cb1b01286ab2'
$msiobjectid = (az webapp identity show --resource-group 'dk-webapp' --name 'dk-webapp' --query principalId --output tsv)
az ad group member add --group $groupid --member-id $msiobjectid
az ad group member list -g $groupid