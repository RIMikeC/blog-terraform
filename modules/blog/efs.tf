resource "aws_efs_file_system" "shared" {
  creation_token = "mine"
}

resource "aws_security_group" "efs" {
  description = "controls direct access to EFS volume"
  name        = "efs-sg"
  vpc_id      = "${aws_vpc.default.id}"

  // add rules seperately outside the module
}
