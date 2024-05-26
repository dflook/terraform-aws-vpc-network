resource "aws_cloudwatch_log_group" "flow_logs" {
  name = "${var.vpc.name}-${var.name}"

  retention_in_days = var.retention_in_days

  tags = local.tags
}

resource "aws_flow_log" "main" {
  log_destination = aws_cloudwatch_log_group.flow_logs.arn
  iam_role_arn    = aws_iam_role.flow_logs.arn
  vpc_id          = var.vpc.id
  traffic_type    = "ALL"

  tags = merge(
    {
      Name = var.name
    },
    local.tags
  )
}

data "aws_iam_policy_document" "flow_logs_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "flow_logs" {
  name = "${substr(var.vpc.name, 0, 32)}-${substr(var.name, 0, 31)}"

  assume_role_policy = data.aws_iam_policy_document.flow_logs_trust.json

  tags = merge(
    {
      Name = "${var.vpc.name}-${var.name}"
    },
    local.tags
  )
}

data "aws_iam_policy_document" "flow_logs" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
    ]

    resources = [
      aws_cloudwatch_log_group.flow_logs.arn,
      "${aws_cloudwatch_log_group.flow_logs.arn}/*"
    ]
  }
}

resource "aws_iam_role_policy" "flow_logs" {
  name = "flow-logs"
  role = aws_iam_role.flow_logs.id

  policy = data.aws_iam_policy_document.flow_logs.json
}
