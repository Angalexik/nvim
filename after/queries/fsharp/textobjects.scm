(declaration_expression
	(function_or_value_defn
		body: (_) @function.inner) @function.outer)
(fun_expression
	(argument_patterns)
	(_)+ @function.inner) @function.outer
