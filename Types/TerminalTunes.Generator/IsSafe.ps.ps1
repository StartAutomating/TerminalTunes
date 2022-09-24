[ValidateScriptBlock(
    ExcludeCommand='*',
    NoWhileLoop,
    IncludeType={
        [int],[math],[timespan], [datetime], 
        [string], [string[]],[int[]], [double[]], 
        [switch]
    }
)]
$ScriptBlockIsSafe = $this.ScriptBlock



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