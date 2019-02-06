resource "aws_efs_file_system" "shared" {
  creation_token = "mine"
}

resource "aws_security_group" "efs" {
  description = "controls direct access to EFS volume"
  name        = "efs-sg"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    description = "NFS"
  }

  egress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    description = "NFS"
  }
}
