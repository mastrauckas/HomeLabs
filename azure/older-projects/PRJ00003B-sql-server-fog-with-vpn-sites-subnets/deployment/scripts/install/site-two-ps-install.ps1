New-AzResourceGroupDeployment `
    -Name site-two-deployment `
    -ResourceGroupName site-two-rg `
    -Verbose `
    -TemplateFile ./main.bicep `
    -TemplateParameterFile ./parameters-json/site-two-parameters.json;