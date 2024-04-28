New-AzResourceGroupDeployment `
    -Name site-one-deployment `
    -ResourceGroupName site-one-rg `
    -Verbose `
    -TemplateFile ./main.bicep `
    -TemplateParameterFile ./parameters-json/site-one-parameters.json;