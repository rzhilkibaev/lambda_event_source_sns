# Configures SNS as Lambda event source 

variable "topic_arn" {}
variable "function_arn" {}
variable "permission_statement_id" { default = "allow_invocation_from_sns" }

resource "aws_lambda_permission" "allow_invocation_from_sns" {
  function_name = "${var.function_arn}"
  statement_id = "${var.permission_statement_id}"
  action = "lambda:InvokeFunction"
  principal = "sns.amazonaws.com"
  source_arn = "${var.topic_arn}"
}

resource "aws_sns_topic_subscription" "invoke_lambda_on_topic_event" {
    topic_arn = "${var.topic_arn}"
    protocol = "lambda"
    endpoint = "${var.function_arn}"
}

