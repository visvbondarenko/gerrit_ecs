resource "aws_eip" "bastion" {
  vpc  = true
  tags = "${merge(local.tags, map("Name", "${var.account_shorthand}-${var.environment}-EIP-BastionHost"))}"
}
