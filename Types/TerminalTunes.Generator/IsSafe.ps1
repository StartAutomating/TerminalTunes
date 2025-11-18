[ValidateScript({
    if ($_ -isnot [ScriptBlock]) { return $true }    
    $astConditions = {
param($ast)
if ($ast -is [Management.Automation.Language.CommandAst]) {
    throw "AST cannot contain commands"
}
return $true} , {param($ast)
$included = [Int32],[Math],[TimeSpan],[DateTime],[String],[String[]],[Int32[]],[Double[]],[Management.Automation.SwitchParameter]
$excluded = '*'
if ($ast -is [Management.Automation.Language.TypeExpressionAst] -or    
    $ast -is [Management.Automation.Language.TypeConstraintAst]) {

    $astType = $ast.TypeName
    $reflectionType = if ($astType) {
        $astType.GetReflectionType()
    }
    

    foreach ($inc in $included) {
        if ($inc -is [string] -and $astType -like $inc) {
            return $true
        }
        elseif ($inc -is [Regex] -and $astType -match $inc) {
            return $true
        }
        elseif ($inc -is [type]){            
            if ($inc -eq $reflectionType) { return $true}
            if ($inc.IsSubclassOf($reflectionType) -or $reflectionType.IsSubclassOf($inc)) {
                return $true
            }
            if ($inc.IsInterface -and $reflectionType.getInterFace($inc)) {
                return $true
            }
            if ($reflectionType.IsInterface -and $inc.getInterFace($reflectionType)) {
                return $true
            }            
        }
    }


    $throwMessage = "[$($ast.Typename)] is not allowed" 
    foreach ($exc in $excluded) {
        if ($exc -is [string] -and $astType -like $exc) {
            throw $throwMessage
        }
        elseif ($exc -is [regex] -and $astType -match $exc) {
            throw $throwMessage
        }
        elseif ($exc -is [type]) {            
            if ($ecx -eq $reflectionType) { 
                throw $throwMessage
            }
            elseif ($exc.IsSubclassOf($reflectionType) -or $reflectionType.IsSubclassOf($exc)) {
                throw $throwMessage
            }
            elseif ($exc.IsInterface -and $reflectionType.getInterFace($exc)) {
                throw $throwMessage
            }
            elseif ($reflectionType.IsInterface -and $exc.getInterFace($reflectionType)) {
                throw $throwMessage
            }            
        }
    }


}
return $true} , {
param($ast)
if ($ast -is [Management.Automation.Language.LoopStatementAst] -and 
    $ast.GetType().Name -match '(?>do|while)') {
    throw "ScriptBlock cannot contain $($ast.GetType().Name)"
}
return $true
}
    $scriptBlockAst = $_.Ast
    foreach ($astCondition in $astConditions) {
        $foundResults = $scriptBlockAst.FindAll($astCondition, $true)
        if (-not $foundResults) { return $false}
    }
    return $true    
})]$ScriptBlockIsSafe = $this.ScriptBlock



<#

$this.ScriptBlock.Ast.FindAll({
    param($ast)
    
    if ($ast -is [Management.Automation.Language.CommandAst]) {
        throw "AST cannot contain commands"
    }

    if ($ast -is [Management.Automation.Language.LoopStatementAst]) {        
        if ($ast.GetType().Name -in 'DoWhileStatementAst','WhileStatementAst', 'DoUntilStatement') {
            throw "Cannot use $($ast.GetType().Name)"
        }
    }
    
    if ($ast -is [Management.Automation.Language.TypeExpressionAst]) {
        $reflectedType  = $ast.TypeName.GetReflectionType()
        if (-not $reflectedType) {
            throw "Could not resolve $($ast.Typename.FullName)"
        }
        if ($reflectedType -notin [Math], [Timespan]) {
            throw "Unacceptable type"
        }
    }
    
}, $true)
#>
return $true
