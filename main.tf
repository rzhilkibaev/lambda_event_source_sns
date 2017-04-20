# Configures SNS as Lambda event source 

variable "topic_name" {}
variable "function_arn" {}

variable "permission_statement_id" { default = "allow_invocation_from_sns" }

resource "aws_sns_topic_subscription" "invoke_lambda_on_topic_event" {
  topic_arn = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.topic_name}"
  protocol  = "lambda"
  endpoint  = "${var.function_arn}"
}

resource "aws_lambda_permission" "allow_invocation_from_sns" {
  function_name = "${var.function_arn}"
  statement_id  = "${var.permission_statement_id}"
  action        = "lambda:InvokeFunction"
  principal     = "sns.amazonaws.com"
  source_arn    = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.topic_name}"
}

data "aws_region" "current" { current = true }

data "aws_caller_identity" "current" {}
