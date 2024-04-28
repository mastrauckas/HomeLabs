New-AzResourceGroupDeployment `
    -Name site-three-deployment `
    -ResourceGroupName site-three-rg `
    -Verbose `
    -TemplateFile ./main.bicep `
    -TemplateParameterFile ./parameters-json/site-three-parameters.json;