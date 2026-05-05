output "budget_name" {
  description = "Name of the AWS budget"
  value       = aws_budgets_budget.monthly_cost_budget.name
}

output "budget_limit" {
  description = "Monthly budget limit in USD"
  value       = aws_budgets_budget.monthly_cost_budget.limit_amount
}