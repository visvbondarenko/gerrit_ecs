output "bastion_public_ip" {
  value = "${aws_eip.bastion.public_ip}"
}

output "bastion_sg" {
  value = "${aws_security_group.bastion.id}"
}
